FROM python:3.12-alpine

WORKDIR /app

COPY . . 

RUN pip install -r requirements.txt 

RUN adduser -D -u 10001 app && \
    chown -R app:app /app

USER app 

EXPOSE 5000

CMD ["python", "main.py"]


