# WORKS PERFECTLY RECEIVE AND SEND !

import socket

def start_server():
    # Create a socket object
    server_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

    # Bind the socket to a specific address and port
    server_address = ('localhost', 12345)
    server_socket.bind(server_address)

    # Listen for incoming connections
    server_socket.listen(1)
    print('Server listening on {}:{}'.format(*server_address))

    while True:
        print('Waiting for a connection...')
        client_socket, client_address = server_socket.accept()
        print('Accepted connection from {}:{}'.format(*client_address))

        try:
            while True:
                # Receive data from the client
                data = client_socket.recv(1024)
                if not data:
                    break  # No more data, end the loop

                frame = data.decode('utf-8')
                # Process the received data (you can replace this with your own logic)
                print('Received data: ', frame)

                # Send a response back to the client (optional)
                response = 'Server received frame ' + frame + '\n'
                client_socket.sendall(response.encode('utf-8'))
                # client_socket.sendall(str(len(response)).encode('utf-8'))

        finally:
            # Clean up the connection
            client_socket.close()
            print('Connection closed')

if __name__ == '__main__':
    start_server()
