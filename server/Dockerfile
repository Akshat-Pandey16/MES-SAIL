FROM python:3.9-slim

WORKDIR /code

COPY ./ /code/

RUN pip install --no-cache-dir --upgrade -r /code/requirements.txt

EXPOSE 80

ENV PYTHONUNBUFFERED=1

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "80"]