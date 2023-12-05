import socket

ADDR = '127.0.0.1'
PORT = 12345


conn = None # Socket connection.


# Handle received data.
def handle_data(data):
    global conn
    
    print('Received data: ', data)
    
    # Send back a response.
    response = 'Python received frame ' + data + '\n' # Sent message have to end with '\n'.
    conn.sendall(response.encode('utf-8'))


# Start the socket.
def start_socket():
    global conn

    # Create a socket object
    server_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

    # Bind the socket to a specific address and port
    server_address = (ADDR, PORT)
    server_socket.bind(server_address)

    # Listen for incoming connections
    server_socket.listen(1)
    print('Server listening on {}:{}'.format(*server_address))

    while True:
        print('Waiting for a connection...')
        conn, socket_addr = server_socket.accept()
        print('Accepted connection from {}:{}'.format(*socket_addr))

        try:
            while True:
                # Receive data from the client
                data = conn.recv(1024)
                handle_data(data.decode('utf-8'))   

        finally:
            # Clean up the connection
            conn.close()
            print('Connection closed')


if __name__ == '__main__':
    start_socket()
