#!/bin/bash

##########################################################
# Server Performance Stats
# Total CPU usage
# Total memory usage (Free vs Used including percentage)
# Total disk usage (Free vs Used including percentage)
# Top 5 processes by CPU usage
# Top 5 processes by memory usage

###########################################################
##functions for linux servers

get_cpu_usage() {
    cpu_usage=$(top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4}')
    echo "Total CPU Usage: $cpu_usage%" 
}
get_memory_usage() {
    memory_usage=$(free | grep "Mem:" | awk '{print $3/$2 * 100.0}')
    echo "Total Memory Usage: $memory_usage%"
}
get_disk_usage() {
    disk_usage=$(df -h / | awk 'NR==2 {print $5}')
    echo "Total Disk Usage: $disk_usage"
}
get_top_cpu_processes() {
    echo "Top 5 Processes by CPU Usage:"
    ps aux --sort=-%cpu | head -n 6 | tail -n 5
}
get_top_memory_processes() {
    echo "Top 5 Processes by Memory Usage:"
    ps aux --sort=-%mem | head -n 6 | tail -n 5
}

## functions for macos servers
get_cpu_usage_macos() {
    cpu_usage=$(top -l 1 | grep "CPU usage" | awk '{print $3 + $5}')
    echo "Total CPU Usage: $cpu_usage%"
}

get_memory_usage_macos() {
    memory_usage=$(vm_stat | grep "Pages active" | awk '{print $3}' | sed 's/\.//')
    total_memory=$(sysctl -n hw.memsize)
    memory_usage_percentage=$(echo "scale=2; ($memory_usage * 4096) / $total_memory * 100" | bc)
    echo "Total Memory Usage: $memory_usage_percentage%"
}
get_disk_usage_macos() {
    disk_usage=$(df -h / | awk 'NR==2 {print $5}')
    echo "Total Disk Usage: $disk_usage"
}
get_top_cpu_processes_macos() {
    echo "Top 5 Processes by CPU Usage:"
    ps -Ao pid,comm,%cpu --sort=-%cpu | head -n 6 | tail -n 5
}
get_top_memory_processes_macos() {
    echo "Top 5 Processes by Memory Usage:"
    ps -Ao pid,comm,%mem --sort=-%mem | head -n 6 | tail -n 5
}   

##function for windows servers
get_cpu_usage_windows() {
    cpu_usage=$(wmic cpu get loadpercentage | awk 'NR==2 {print $1}')
    echo "Total CPU Usage: $cpu_usage%"
}
get_memory_usage_windows() {               
    memory_usage=$(wmic OS get FreePhysicalMemory,TotalVisibleMemorySize /Value | awk -F= 'NR==1 {free=$2} NR==2 {total=$2} END {print (total-free)/total * 100}')
    echo "Total Memory Usage: $memory_usage%"
}
get_disk_usage_windows() {
    disk_usage=$(wmic logicaldisk get size,freespace,caption | awk 'NR==2 {used=$2; total=$3; print used/total * 100}')
    echo "Total Disk Usage: $disk_usage%"
}       
get_top_cpu_processes_windows() {
    echo "Top 5 Processes by CPU Usage:"
    wmic process get name,processid,workingsetsize | sort -k3 -nr | head -n 6 | tail -n 5
}
get_top_memory_processes_windows() {
    echo "Top 5 Processes by Memory Usage:"
    wmic process get name,processid,workingsetsize | sort -k3 -nr | head -n 6 | tail -n 5
}       

##function to check the OS type and call the appropriate functions
check_os_type() {
    os_type=$(uname)
    if [[ "$os_type" == "Linux" ]]; then
        get_cpu_usage
        get_memory_usage
        get_disk_usage
        get_top_cpu_processes
        get_top_memory_processes
    elif [[ "$os_type" == "Darwin" ]]; then
        get_cpu_usage_macos
        get_memory_usage_macos
        get_disk_usage_macos
        get_top_cpu_processes_macos
        get_top_memory_processes_macos
    elif [[ "$os_type" == "Windows_NT" ]]; then
        get_cpu_usage_windows
        get_memory_usage_windows
        get_disk_usage_windows
        get_top_cpu_processes_windows
        get_top_memory_processes_windows
    else
        echo "Unsupported OS type: $os_type"
    fi
}

## Main script execution
check_os_type
