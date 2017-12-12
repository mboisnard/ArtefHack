import json

# NB : accounts[0] => Admin address
#      accounts[1] => ArtefHack address
#      accounts[2] => Publisher address
#      accounts[3] => Advertiser address

USERS_STARTING_INDEX = 4

def verify_input_arguments(starting_users_count, max_users_count, days_count, contents_count):
	if days_count <= 0 or days_count > 100:
		raise ValueError("The simulation must last between 1 and 100 days")
	if starting_users_count <= 0 or starting_users_count > 1000:
		raise ValueError("There must be between 1 and 1000 users at the start of the simulation")
	if max_users_count <= 0 or max_users_count > 1000:
		raise ValueError("There must be between 1 and 1000 total users in the simulation")
	if starting_users_count > max_users_count:
		raise ValueError("There can't be more users at the start of the simulation than the total number of users")
	if contents_count <= 0 or contents_count > 800:
		raise ValueError("There must be between 1 and 800 users")

def contract_deploy_data(contract):
	with open('../build/contracts/{}.json'.format(contract)) as f:
		deploy_data = json.load(f)
	return deploy_data

def setup_contract_instances(web3):
    contract_metadata = {}
    contract_instances = {}
    for el in ['ArtefHack', 'Balances', 'Publisher', 'RolesStorage']:
        contract_metadata[el] = contract_deploy_data(el)
        network_id = list(contract_metadata[el]["networks"].keys())[-1]
        contract_instances[el] = web3.eth.contract(
    		contract_metadata[el]['abi'],
    		contract_metadata[el]["networks"][network_id]['address']
    	)
    return contract_instances

def load_data(variable):
    with open('./data/{}.json'.format(variable)) as f:
    	data = json.load(f)[variable]
    return data

def setup_users(whole_dataset, count, overhead=0):
    data = {}
    for i in range(overhead, overhead + count):
    	data[str(i)] = {}
    	data[str(i)] = whole_dataset[str(i)]
    return data

def insert_contents(contract_instances, contents, accounts):
    for el in contents:
    	contract_instances['Publisher'].transact(
			{'from': accounts[2], 'gas': 200000}
		).insertContent(
    		bytearray(el['id'], 'utf-8'),
    		el['preference']
		)

def set_stakeholders(contract_instances, accounts):
	contract_instances['ArtefHack'].transact({'from': accounts[0], 'gas':200000}).setArtefHack(accounts[1])
	contract_instances['Publisher'].transact({'from': accounts[0], 'gas':200000}).setPublisher(accounts[2])

def set_roles(contract_instances, accounts, users_count):
	for idx, role in enumerate(['ArtefHack', 'Publisher', 'Advertiser']):
	    contract_instances['RolesStorage'].transact(
			{'from':accounts[0], 'gas':100000}
		).setRole(accounts[idx + 1], role)
	for u in range(USERS_STARTING_INDEX, USERS_STARTING_INDEX + users_count):
		contract_instances['RolesStorage'].transact(
			{'from':accounts[0], 'gas':100000}
		).setRole(accounts[u], 'User')

def set_balances(contract_instances, accounts, users_count):
	# create balances for all addresses
	for ad in accounts:
		contract_instances['Balances'].transact({'from': accounts[0], 'gas':200000}).create(ad)

	# fund admin's balance
	contract_instances['Balances'].transact({'from': accounts[0], 'gas':200000}).fund(1000000)

	# set initial balance for stakeholders
	contract_instances['Balances'].transact({'from': accounts[0], 'gas':100000}).pay(accounts[0], accounts[1], 2000)
	contract_instances['Balances'].transact({'from': accounts[0], 'gas':100000}).pay(accounts[0], accounts[3], 50000)

	# set initial balance for all other users
	for u in range(USERS_STARTING_INDEX, USERS_STARTING_INDEX + users_count):
		contract_instances['Balances'].transact({'from': accounts[0], 'gas':100000}).pay(accounts[0], accounts[u], 50)

def log_results(visits, satisfied_visits, publisher_revenue, ad_views):
    print('')
    print('Done!')
    print('')
    print(
        'Your implementation generated {} visits with a {} % satisfaction rate, {} token revenue for the publisher, and {} ad views!'.format(
            visits,
            round((satisfied_visits / visits) * 100),
            publisher_revenue,
            ad_views
        )
    )

    print(
		'Your score is {}'.format(
        	generate_score(visits, satisfied_visits, publisher_revenue)
        )
    )
    print('')

def generate_score(visits, satisfied_visits, publisher_revenue):
    return int(visits + satisfied_visits + publisher_revenue / 10)
