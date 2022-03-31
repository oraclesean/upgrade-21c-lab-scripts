CONTAINER_NAME=$(docker ps --format "{{.Names}}")
docker exec -it $CONTAINER_NAME bash -c "tail -f /opt/oracle/oradata/autoupgrade/LAB/101/autoupgrade_*.log"
