import pickle


def load_from(store_file):
    with open(store_file, 'rb') as file:
        return pickle.load(file)
