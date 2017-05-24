FROM python:2

RUN pip install pandas && \
    pip install numpy && \
    # clean up pip cache
    rm -rf /root/.cache/pip/*

RUN mkdir /src
COPY . /src

#Default - Run a sample numpy program
CMD python /src/numpy-sum.py
