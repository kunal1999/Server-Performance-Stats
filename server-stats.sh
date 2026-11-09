#!/bin/bash

##########################################################
# Server Performance Stats
# Total CPU usage
# Total memory usage (Free vs Used including percentage)
# Total disk usage (Free vs Used including percentage)
# Top 5 processes by CPU usage
# Top 5 processes by memory usage

###########################################################


## check which operating system is running
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    echo "Running on Linux"
    ## call function for linux system to get CPU, memory, disk usage and top processes
    get_cpu_usage
    get_memory_usage
    get_disk_usage
    get_top_cpu_processes
    get_top_memory_processes


elif [[ "$OSTYPE" == "darwin"* ]]; then
    echo "Running on macOS"
    ##call function for macOS system to get CPU, memory, disk usage and top processes
    get_cpu_usage
    get_memory_usage
    get_disk_usage
    get_top_cpu_processes
    get_top_memory_processes
    
else
    echo "Unsupported operating system"
    exit 1
fi  
## Function to get total CPU usage
get_cpu_usage() {
    cpu_usage=$(top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4}')
    echo "Total CPU Usage: $cpu_usage%" 
}

## Function to get total memory usage
get_memory_usage() {
    memory_usage=$(free | grep "Mem:" | awk '{print $3/$2 * 100.0}')
    echo "Total Memory Usage: $memory_usage%"
}

## Function to get total disk usage
get_disk_usage() {
    disk_usage=$(df -h / | awk 'NR==2 {print $5}')
    echo "Total Disk Usage: $disk_usage"
}

## Function to get top 5 processes by CPU usage
get_top_cpu_processes() {
    echo "Top 5 Processes by CPU Usage:"
    ps aux --sort=-%cpu | head -n 6 | tail -n 5
}

## Function to get top 5 processes by memory usage
get_top_memory_processes() {
    echo "Top 5 Processes by Memory Usage:"
    ps aux --sort=-%mem | head -n 6 | tail -n 5
}
