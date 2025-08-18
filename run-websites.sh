#!/bin/bash

# Script to run 5 websites on ports 5000-5004
# Usage: ./run-websites.sh [start|stop|restart]

# Define the website directories and their corresponding ports
WEBSITES=(
    "vapp_pro_ind_co:5000"
    "Vapp_new_ind_com:5001"
    "vapp_lux_pro_ncr_com:5002"
    "Vapp_lux_pro_ncr_co:5003"
    "Vapp_lux_pro_ind_co_in:5004"
)

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to check if a port is in use
port_in_use() {
    lsof -i :$1 >/dev/null 2>&1
}

# Function to start all websites
start_websites() {
    echo -e "${BLUE}Starting all websites...${NC}"
    
    for website in "${WEBSITES[@]}"; do
        IFS=':' read -r folder port <<< "$website"
        
        if [ ! -d "$folder" ]; then
            echo -e "${RED}Error: Directory $folder not found!${NC}"
            continue
        fi
        
        if port_in_use $port; then
            echo -e "${YELLOW}Warning: Port $port is already in use. Skipping $folder${NC}"
            continue
        fi
        
        echo -e "${GREEN}Starting $folder on port $port...${NC}"
        
        # Start a simple HTTP server in the background
        if command -v python3 &> /dev/null; then
            (cd "$folder" && python3 -m http.server $port > /dev/null 2>&1 &)
        elif command -v python &> /dev/null; then
            (cd "$folder" && python -m http.server $port > /dev/null 2>&1 &)
        elif command -v node &> /dev/null; then
            (cd "$folder" && npx http-server -p $port > /dev/null 2>&1 &)
        else
            echo -e "${RED}Error: No suitable HTTP server found. Please install Python or Node.js${NC}"
            exit 1
        fi
        
        sleep 1
    done
    
    echo -e "${GREEN}All websites started successfully!${NC}"
    echo -e "${BLUE}Access your websites at:${NC}"
    for website in "${WEBSITES[@]}"; do
        IFS=':' read -r folder port <<< "$website"
        echo -e "  ${GREEN}http://localhost:$port${NC} - $folder"
    done
}

# Function to stop all websites
stop_websites() {
    echo -e "${BLUE}Stopping all websites...${NC}"
    
    for website in "${WEBSITES[@]}"; do
        IFS=':' read -r folder port <<< "$website"
        
        # Find and kill the process using this port
        PID=$(lsof -ti :$port 2>/dev/null)
        if [ -n "$PID" ]; then
            echo -e "${GREEN}Stopping $folder on port $port (PID: $PID)${NC}"
            kill $PID
        fi
    done
    
    echo -e "${GREEN}All websites stopped.${NC}"
}

# Function to show status
show_status() {
    echo -e "${BLUE}Website Status:${NC}"
    
    for website in "${WEBSITES[@]}"; do
        IFS=':' read -r folder port <<< "$website"
        
        if port_in_use $port; then
            PID=$(lsof -ti :$port 2>/dev/null)
            echo -e "  ${GREEN}✓${NC} $folder on port $port (PID: $PID)"
        else
            echo -e "  ${RED}✗${NC} $folder on port $port - Not running"
        fi
    done
}

# Main script logic
case "${1:-start}" in
    start)
        start_websites
        ;;
    stop)
        stop_websites
        ;;
    restart)
        stop_websites
        sleep 2
        start_websites
        ;;
    status)
        show_status
        ;;
    *)
        echo "Usage: $0 [start|stop|restart|status]"
        echo ""
        echo "Commands:"
        echo "  start   - Start all websites on ports 5000-5004"
        echo "  stop    - Stop all running websites"
        echo "  restart - Restart all websites"
        echo "  status  - Show running status of all websites"
        exit 1
        ;;
esac