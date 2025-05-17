# eink-dash-rstats

## Local development

```bash
docker build -t eink-dash .
docker run  -p 6123:6123 eink-dash:latest
```

Sample requests:

```bash
curl "http://127.0.0.1:6123/"
curl -X POST "http://127.0.0.1:6123/toggle/lamp"
```
