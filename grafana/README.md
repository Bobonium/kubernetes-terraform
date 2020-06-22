# grafana

- dashboards
  - should be a map of maps
  - keys of outer map should be the name of the directory (without the path) that should be mounted
  - keys of the inner map should be the name of the dashboard file
  - values of the inner map should be the dashboard json content
- provisioningYml
  - should be yml content
  - path should always be `/var/lib/grafana/dashboards/${DIRECTORY}`
    - ${DIRECTORY} should be equal to the key of the inner map of `dashboards`
- datasourcesYml
  - should be yml content
 