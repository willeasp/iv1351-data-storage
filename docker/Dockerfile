FROM python:3.7-slim

# install Python 3
RUN apt-get update && apt-get install -y libpq-dev gcc

# install psycopg2 library with PIP
RUN pip3 install psycopg2

CMD [ "bash" ]

# ENTRYPOINT [ "/bin/bash" ]

# CMD [ "python3" ]