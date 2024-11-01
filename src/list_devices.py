import torch

def list_cuda_devices():
    """
    Lists all available CUDA devices along with their names.
    If no CUDA devices are available, it informs the user.
    """
    try:
        # Check if CUDA is available
        if torch.cuda.is_available():
            devices = [f"cuda:{i} => {torch.cuda.get_device_name(i)}" for i in range(torch.cuda.device_count())]
            # Print the list of devices
            if devices:
                print("Available CUDA devices:")
                for device in devices:
                    print(device)
            else:
                print("No CUDA devices found.")
        else:
            print("CUDA is not available on this machine.")
    except Exception as e:
        print(f"An error occurred while listing devices: {e}")

if __name__ == "__main__":
    list_cuda_devices()
