#!/bin/bash -e

CWD=$(realpath "$(dirname "$0")")

get_os_name() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        echo "mac"
        return
    fi

    if grep -qi "microsoft" /proc/version; then
        echo "wsl"
        return
    fi

    if [[ -f /etc/os-release ]]; then
        . /etc/os-release
        case "$ID" in
            ubuntu)
                echo "ubuntu"
                return
                ;;
            arch)
                echo "arch"
                return
                ;;
            linuxmint)
                echo "mint"
                return
                ;;
        esac
    fi

    echo "unknown"
}

for installer in "$CWD/install.0.*.$(get_os_name).sh"; do
    "$installer"
done

for installer in "$CWD/install.*.$(get_os_name).sh"; do
    "$installer"
done
