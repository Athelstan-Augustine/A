function Menu() {
    echo "-----------------------------------------------------------------"
    echo "Choose what you want to do! "
    echo "1: Load U Disk! "
    echo "2: Unload U Disk! "
    echo "3: Check U Disk information! "
    echo "4: Copy file to U Disk! "
    echo "*: Exit! "
    echo "-----------------------------------------------------------------"
    echo ""

}

function LoadUDisk() {
    CheckUDiskCount
    for ((i = 1; i <= uDiskCount; i++)); do
        if [ ! -d /mnt/usb${i} ]; then
            echo "No path /mnt/usb$i ,ready to create it for you! "
            sudo mkdir /mnt/usb${i}
            echo "Success to make path /mnt/usb$i! "
        fi
        echo "Loading U Disk $i....."
        sudo mount /dev/sdb$i /mnt/usb$i
        echo "Success to load U Disk $i!"
    done

    echo "Success to laod all U Disks ! "done

    read -p "Press any key to continue: " -n 1

}
function UnLoadUDisk() {
    for ((i = 1; i <= $uDiskCount; i++)); do
        echo "Is unlodading U Disk ${i}....."
        sudo umount /mnt/usb${i}
        echo "Success to unload U Disk $i"
    done
    sudo rm -rf /mnt/*
    echo ""
    read -p "Press any key to continue: " -n 1

}
function CheckInformation() {
    sudo fdisk -l | grep sdb
    echo ""
    for ((i = 1; i <= $uDiskCount; i++)); do
        echo "${i} U Disk :"
        ls /mnt/usb$i
        echo ""
    done
    read -p "Press any key to continue: " -n 1
}
function CopyFileToUDisk() {
    while true; do

        read -p "Input  targetFile: " targetFile
        if [ ! -e $targetFile ]; then
            echo "No file \"$targetFile\" ! (Press Y/y to continue,N/n to exit !)"
            read -n 1 key
            if [ key != "Y" ] && [ key != "y" ]; then
                return 0
            fi
        else
            read -p "Input sourceFile: " sourceFile
            if [ ! -e $sourceFile ]; then
                read -n 1 -p "No file $sourceFile! (Press Y/y to create it,N/n to exit !): " key
                if [ key != "Y" ] && [ key != "y" ]; then
                    sudo touch $sourceFile
                else
                    return 0
                fi
            fi
            sudo cp  $sourceFile $targetFile
            read -n 1 -p "Want to exit(Y/N)?" key
            if [ key != "Y" ] && [ key != "y" ]; then
                                Exit
            fi
        fi

    done
}

function ReadValue() {
    echo ""
    read -n 1 -p "Make your choice: " v
    echo ""
    echo ""
    case ${v} in
    1)
        LoadUDisk
        ;;
    2)
        UnLoadUDisk
        ;;
    3)
        CheckInformation
        ;;
    4)
        CopyFileToUDisk
        ;;
    *)
        Exit
        ;;
    esac
}

function CheckUDiskCount() {
    uDiskCount=$(find /dev -name sdb* | wc -l)
    uDiskCount=$((uDiskCount - 1))
    if [ $uDiskCount -gt 0 ]; then
        echo "Find $uDiskCount U Disk in you computer!"
    else
        echo "Find 0 U Disk on you computer!"
    fi
}
function Exit() {
    for ((i = 1; i <= $uDiskCount; i++)); do
        echo "Is unlodading U Disk ${i}....."
        sudo umount /mnt/usb${i}
        echo "Success to unload U Disk $i"
    done
    sudo rm -rf /mnt/*
    echo ""
    exit 0

}

uDiskCount=0

while true; do
    Menu
    ReadValue
done
