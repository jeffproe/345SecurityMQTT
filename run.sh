#!/usr/bin/env bashio

if bashio::services.available "mqtt"; then
    export MQTT_HOST=$(bashio::services "mqtt" "host")
    export MQTT_PASSWORD=$(bashio::services "mqtt" "password")
    export MQTT_PORT=$(bashio::services "mqtt" "port")
    export MQTT_USERNAME=$(bashio::services "mqtt" "username")
else
    bashio::log.info "The mqtt addon is not available."
    bashio::log.info "Manually update the output line in the configuration file with mqtt connection settings, and restart the addon."
    exit $?
fi

AUTODISCOVERY=$(bashio::config "autodiscovery")
DEVICE_ID=$(bashio::config "device_id")
FREQUENCY=$(bashio::config "frequency")
SAMPLE_RATE=$(bashio::config "sample_rate")
GAIN=$(bashio::config "gain")

echo "Starting 345toMqtt -d $DEVICE_ID -f $FREQUENCY -a $AUTODISCOVERY -g $GAIN -s $SAMPLE_RATE"
./345toMqtt -d $DEVICE_ID -f $FREQUENCY -a $AUTODISCOVERY -g $GAIN -s $SAMPLE_RATE"
echo "Exiting run.sh"
exit $?
