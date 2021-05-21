FROM python:3.6.11-alpine
LABEL maintainer="kaka <vn503024@gmail.com>"

WORKDIR /code
COPY requirements.txt requirements.txt
RUN pip install -r requirements.txt
COPY . .

CMD ["python", "app.py"]
