import dataset

db = dataset.connect('sqlite:///users.db?check_same_thread=False')
users = db['users']