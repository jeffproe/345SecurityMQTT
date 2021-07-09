# 345SecurityMQTT

This project is based [jlt24's 345SecurityMQTT](https://github.com/jlt24/345SecurityMQTT) project which is based on [fusterjj's HonewellSecurityMQTT](https://github.com/fusterjj/HoneywellSecurityMQTT) project which was based on [jhaines0's HoneywellSecurity](https://github.com/jhaines0/HoneywellSecurity).  It listen's for events from 345MHz security sensors and sends messages via MQTT.  

It is a simple event/message translation, but some state/persistance was required to acheive debouncing of signals.

## Features
 - Decodes data from sensors based on Honeywell's 345MHz system.  This includes rebrands such as 2GIG, Vivint, etc.
 - Requires no per-sensor configuration
 - Decodes sensor status such as tamper and low battery
 - Reports alarm and sensor status to an MQTT broker
 - Support for multisensors.  For example, a water sensor with high-temp and low-temp alerts.
 - Support for some 345 keyfobs and 345 keypads.

## Requirements
 - RTL-SDR USB adapter; commonly available on Amazon
 - rtlsdr library
 - mosquittopp library
 - gcc

## Installation
### Dependencies
On a Debian-based system, something like this should work:
```
  sudo apt-get install build-essential librtlsdr-dev rtl-sdr libmosquittopp-dev
```

To avoid having to run as root, you can add the following rule to a file in `/etc/udev/rules.d`:
```
  SUBSYSTEMS=="usb", ATTRS{idVendor}=="0bda", ATTRS{idProduct}=="2838", MODE:="0660", GROUP:="audio"
```

Then add the desired user to the `audio` group.
If you plugged in the RTL-SDR before installing rtl-sdr, you probably will need to do something like `sudo rmmod rtl2832 dvb_usb_rtl28xxu` then remove and reinstall the adapter.

### Configuration
Modify `mqtt_config.h` to specify the host, port, username, and password of your MQTT broker.  If `""` is used for the username or password, then an anonymous login is attempted.  Also, the payloads of some signals can be configured.

### Building
```
  cd src
  ./build.sh
```

### Running
  `./345toMqtt`

#### Command line flags
| Flag          | Meaning   | Default    |
|---------------|-----------|------------|
| `-d` <int>    | Device id | 0          |
| `-f` <int>    | Frequency | 345000000  |

#### Environment variables

These environment variables will override the values set in `mqtt_config.h`

| Variable name   | Meaning                                          |
|-----------------|--------------------------------------------------|
| `MQTT_HOST`     | Hostname or IP address of the MQTT server        |
| `MQTT_PORT`     | Port of the MQTT server                          |
| `MQTT_USERNAME` | Username to use for logging into the MQTT server |
| `MQTT_PASSWORD` | Password for the provided username               |

### MQTT Message Format

| Topic                                               | Payload                 | Retain |
|-----------------------------------------------------|-------------------------|--------|
| security/sensors345/sensor/`<txid>`/loop`<N>`       | `OPEN` or `CLOSED`      | Yes    |
| security/sensors345/sensor/`<txid>`/tamper          | `TAMPER` or `OK`        | Yes    |
| security/sensors345/sensor/`<txid>`/battery         | `LOW` or `OK`           | Yes    |
| security/sensors345/keypad/`<txid>`/keypress        | `0`, `1`, `2`, `3`, `4`, `5`, `6`, `7`, `8`, `9`, `*`, `#`, `STAY`, `AWAY`, `FIRE`, `POLICE` | No |
| security/sensors345/keypad/`<txid>`/keyphrase/<LEN> | Numbers (or `#` or `*` entered within 2 seconds of each other.  Regex: `[*#0-9]{2,}` | No |
| security/sensors345/keyfob/`<txid>`/keypress        | `STAY`, `AWAY`, `DISARM`, `AUX` | No |

