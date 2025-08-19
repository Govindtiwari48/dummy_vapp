# Multi-Website Manager

This repository contains 5 static websites and scripts to manage them efficiently.

## Quick Start

### Option 1: Use run-websites.sh (Recommended for static sites)
```bash
# Make script executable
chmod +x run-websites.sh

# Start all websites
./run-websites.sh start

# Check status
./run-websites.sh status

# Stop all websites
./run-websites.sh stop

# Restart all websites
./run-websites.sh restart
```

### Option 2: Use run-projects.sh (For Node.js projects)
```bash
# Make script executable
chmod +x run-projects.sh

# Install dependencies (if needed)
npm install -g serve pm2

# Run the script
./run-projects.sh
```

## Website URLs

| Website | Port | URL |
|---------|------|-----|
| vapp_pro_ind_co | 5000 | http://localhost:5000 |
| Vapp_new_ind_com | 5001 | http://localhost:5001 |
| vapp_lux_pro_ncr_com | 5002 | http://localhost:5002 |
| Vapp_lux_pro_ncr_co | 5003 | http://localhost:5003 |
| Vapp_lux_pro_ind_co_in | 5004 | http://localhost:5004 |

## Requirements

- Python 3+ (for run-websites.sh) OR
- Node.js + npm (for run-projects.sh)
- Optional: `serve` and `pm2` packages (for run-projects.sh)

## Usage Examples

```bash
# Start websites on ports 5000-5004
./run-websites.sh start

# Check which websites are running
./run-websites.sh status

# Stop all running websites
./run-websites.sh stop

# Restart all websites
./run-websites.sh restart
```

## Troubleshooting

- If ports are already in use, the script will skip those websites
- Check status to see which websites are running
- Use `lsof -ti :5000` to check what's using a specific port