iperf3
=====

For: https://hub.docker.com/repository/docker/slashdoom/iperf3/general

### iperf3 Docker Build for Network Performance and Bandwidth Testing

- Binaries and source code for the project can be found at https://downloads.es.net/pub/iperf/
- A GitHub repo with the Dockerfile can be found at https://github.com/slashdoom/iperf3-docker

### Run the Docker Image and Show the iperf3 Options
    docker run -it --rm -p 5201:5201 slashdoom/iperf3 --help

### Usage
To test bandwidth between two containers, start a server (listener) and point a client container (initiator) at the server.

#### iperf3 Server
Start a listener service on port 5201 and name the container "iperf3-server":

    docker run  -it --rm --name=iperf3-server -p 5201:5201 slashdoom/iperf3 -s

This creates an iperf3 process bound to port 5201 waiting for new connections:

    -----------------------------------------------------------
    Server listening on 5201
    -----------------------------------------------------------`

#### iperf3 Client
First, get the IP address of the new server container you just started:

    docker inspect --format "{{ .NetworkSettings.IPAddress }}" iperf3-server
    172.17.0.2   <~~ returned container IP

Next, initiate a client connection from another container to measure the bandwidth between the two endpoints.

Run a client container pointing at the server container's IP address.

    docker run  -it --rm slashdoom/iperf3 -c 172.17.0.2

And the output is the following:

    Connecting to host 172.17.0.2, port 5201
    [  5] local 172.17.0.3 port 50800 connected to 172.17.0.2 port 5201
    [ ID] Interval           Transfer     Bitrate         Retr  Cwnd
    [  5]   0.00-1.00   sec  6.39 GBytes  54.9 Gbits/sec   47   1.65 MBytes
    [  5]   1.00-2.00   sec  7.25 GBytes  62.3 Gbits/sec    0   1.65 MBytes
    [  5]   2.00-3.00   sec  6.63 GBytes  57.0 Gbits/sec    0   1.65 MBytes
    [  5]   3.00-4.00   sec  7.80 GBytes  67.0 Gbits/sec    0   1.65 MBytes
    [  5]   4.00-5.00   sec  7.34 GBytes  63.0 Gbits/sec    0   1.65 MBytes
    [  5]   5.00-6.00   sec  7.09 GBytes  60.9 Gbits/sec    1   1.65 MBytes
    [  5]   6.00-7.00   sec  6.67 GBytes  57.3 Gbits/sec    0   1.65 MBytes
    [  5]   7.00-8.00   sec  6.61 GBytes  56.7 Gbits/sec    0   1.65 MBytes
    [  5]   8.00-9.00   sec  6.45 GBytes  55.4 Gbits/sec    0   1.65 MBytes
    [  5]   9.00-10.00  sec  6.56 GBytes  56.3 Gbits/sec    0   1.65 MBytes
    - - - - - - - - - - - - - - - - - - - - - - - - -
    [ ID] Interval           Transfer     Bitrate         Retr
    [  5]   0.00-10.00  sec  68.8 GBytes  59.1 Gbits/sec   48             sender
    [  5]   0.00-10.00  sec  68.8 GBytes  59.1 Gbits/sec                  receiver
    
    iperf Done.

### Hat Tips
- [ESnet](https://www.es.net/) - for re-rolling iperf3 from the ground up. It is an excellent piece of software.
- [networkstatic](https://networkstatic.net/) - for the iperf3 image this is mostly based on.  We used this until we need features in latest iperf3 versions.
