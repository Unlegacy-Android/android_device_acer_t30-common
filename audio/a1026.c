/*
 * Copyright (C) 2011 The Android Open Source Project
 * Copyright (C) 2017 The Unlegacy Android Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#define LOG_TAG "a1026"

#include "a1026.h"

#include <dlfcn.h>
#include <errno.h>
#include <fcntl.h>
#include <cutils/log.h>
#include <sys/ioctl.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <termios.h>

/* IOCTLs for Audience A1026 */
#define A1026_IOCTL_MAGIC 'u'
#define A1026_UART_SYNC_CMD         _IOW(A1026_IOCTL_MAGIC, 0x03, void *)
#define A1026_DOWNLOAD_MODE         _IOW(A1026_IOCTL_MAGIC, 0x04, void *)
#define A1026_SET_CONFIG            _IOW(A1026_IOCTL_MAGIC, 0x05, enum A1026_TableID)
#define A1026_NOISE_LEVEL           _IOW(A1026_IOCTL_MAGIC, 0x06, enum Noise_Level_Value)

static int fd_dev = -1;

int a1026_send_boot_cmd(int fd)
{
    int ret;
    uint8_t buf[2] = { 0, 1 };

    ret = write(fd, &buf, 2);
    if (ret < 2) {
        ALOGE("%s: write failed (%d)", __func__, errno);
        return -1;
    }

    usleep(10000);

    ret = read(fd, &buf, 2);
    if (ret < 2) {
        ALOGE("%s: read failed (%d)", __func__, errno);
        return -1;
    }

    if (!(buf[0] == 0 && buf[1] == 1)) {
        ALOGE("Boot command ACK error");
    }

    return ret;
}

int uart_set_baud_rate(int fd, speed_t speed)
{
    int ret;
    struct termios options;

    ret = tcgetattr(fd, &options);
    if (ret < 0) {
        ALOGE("%s: tcgetattr failed (%d)", __func__, errno);
        return ret;
    }

    ret = cfsetispeed(&options, speed);
    if (ret < 0) {
        ALOGE("%s: cfsetispeed failed (%d)", __func__, errno);
        return ret;
    }

    ret = cfsetospeed(&options, speed);
    if (ret < 0) {
        ALOGE("%s: cfsetospeed failed (%d)", __func__, errno);
        return ret;
    }

    // 8N1 mode
    options.c_cflag |= CS8 | CLOCAL | CREAD;

    // turn off output processing
    options.c_oflag = 0;

    // turn off line processing
    options.c_lflag = 0;

    ret = tcsetattr(fd, TCSANOW, &options);
    if (ret < 0) {
        ALOGE("%s: tcsetattr failed (%d)", __func__, errno);
        return ret;
    }

    return 0;
}

int firmware_write(char *fw_path, int to_fd)
{
    int fd, ret, remaining, towrite;
    uint8_t *p, *p_seek;
    struct stat sb;

    fd = open(fw_path, O_RDONLY);
    if (fd < 0) {
        ALOGE("Error %d opening %s", errno, fw_path);
        return -1;
    }

    ret = fstat(fd, &sb);
    if (ret < 0) {
        ALOGE("%s: fstat failed (%d)", __func__, errno);
        return -1;
    }

    p = mmap(0, sb.st_size, PROT_READ, MAP_SHARED, fd, 0);
    if (p == MAP_FAILED) {
        ALOGE("%s: mmap failed (%d)", __func__, errno);
        return -1;
    }

    close(fd);

    p_seek = p;

    remaining = sb.st_size;
    while (remaining) {
        if (remaining > 4096)
            towrite = 4096;
        else
            towrite = remaining;
        ret = write(to_fd, p_seek, towrite);
        if (ret < towrite) {
            ALOGE("Error %d writing to /dev/ttyHS3", errno);
            return -1;
        }
        remaining -= towrite;
        p_seek += towrite;
        usleep(10000);
    }

    ret = munmap(p, sb.st_size);
    if (ret < 0) {
        ALOGE("%s: munmap failed (%d)", __func__, errno);
        return 0;
    }

    return 0;
}

int a1026_init() {
    int ret = 0;

    fd_dev = open("/dev/audience_a1026", 0);
    if (fd_dev < 0) {
        ALOGE("Error %d opening /dev/audience_a1026", errno);
        return -1;
    }

    int fd_uart = open("/dev/ttyHS3", O_RDWR | O_NOCTTY);
    if (fd_uart < 0) {
        ALOGE("Error %d opening /dev/ttyHS3", errno);
        goto err;
    }

    ret = uart_set_baud_rate(fd_uart, B230400);
    if (ret < 0) {
        ALOGE("Failed to setup serial connection");
        goto err;
    }

    ret = ioctl(fd_dev, A1026_DOWNLOAD_MODE, 0);
    if (ret < 0) {
        ALOGE("Failed to enter download mode");
        goto err;
    }

    usleep(10000);

    ret = a1026_send_boot_cmd(fd_uart);
    if (ret < 0) {
        ALOGE("Failed to initialize A1026");
        goto err;
    }

    ALOGD("Stage 1 boot completed");

    ret = firmware_write("/vendor/firmware/UartSet3Mbps.bin", fd_uart);
    if (ret < 0) {
        ALOGE("Failed to write firmware");
        goto err;
    }

    usleep(100000);

    ret = uart_set_baud_rate(fd_uart, B3000000);
    if (ret < 0) {
        ALOGE("Failed to setup serial connection");
        goto err;
    }

    ret = a1026_send_boot_cmd(fd_uart);
    if (ret < 0) {
        ALOGE("Failed to initialize A1026");
        goto err;
    }

    ALOGD("Stage 2 boot completed");

    ret = firmware_write("/vendor/firmware/es305.bin", fd_uart);
    if (ret < 0) {
        ALOGE("Failed to write firmware");
        goto err;
    }

    close(fd_uart);

    usleep(150000);

    ret = ioctl(fd_dev, A1026_UART_SYNC_CMD, 0);
    if (ret < 0) {
        ALOGE("Sync command failed");
        goto err;
    }

    ALOGD("Initialized");

err:
    close(fd_uart);
    return ret;
}

int a1026_set_config(enum A1026_TableID mode) {
    int ret;

    if (fd_dev < 0) {
        ALOGE("Unable to access A1026 device");
        return -1;
    }

    ret = ioctl(fd_dev, A1026_SET_CONFIG, &mode);
    if (ret < 0) {
        ALOGE("Unable to set mode to %d (%d)", mode, errno);
        return ret;
    }

    return 0;
}
