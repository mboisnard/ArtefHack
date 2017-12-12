
import click
from web3 import Web3, HTTPProvider

from functions.setup import *
from functions.simulation import *

USERS_STARTING_INDEX = 4

@click.command()
@click.option('--setup', type=bool, default=True)
@click.option('--starting-users-count', type=int, default=100)
@click.option('--max-users-count', type=int, default=1000)
@click.option('--days-count', type=int, default=100)
@click.option('--contents-count', type=int, default=400)
def run(setup, starting_users_count, max_users_count, days_count, contents_count):

	verify_input_arguments(starting_users_count, max_users_count, days_count, contents_count)

	provider = HTTPProvider('http://localhost:8545')
	web3 = Web3(provider)

	accounts = web3.eth.accounts
	contract_instances = setup_contract_instances(web3)

	# setup users and contents
	users = load_data("users")
	users = {
		str(el): users[str(el)] for el in range(USERS_STARTING_INDEX, USERS_STARTING_INDEX + max_users_count)
	}
	contents = load_data("contents")
	contents = contents[0:contents_count]
	users_contents_matrix = load_data("users_contents_matrix")
	current_users = setup_users(
		users,
		starting_users_count,
		USERS_STARTING_INDEX
	)
	users_involved = starting_users_count
	current_contents = []

	if setup:
		print('')
		print('\033[1mSetup of the simulation\033[0m')
		print('')

		print('Setting roles')
		set_roles(contract_instances, accounts, len(users))
		print('Done! Roles have been set for the stakeholders and {} users'.format(len(users)))
		print('')

		# make contents available in the catalogue
		print('Inserting contents...')
		insert_contents(contract_instances, contents, accounts)
		print('Done! {} contents have been created'.format(len(contents)))
		print('')

		print('Setting ArtefHack and Publisher addresses')
		set_stakeholders(contract_instances, accounts)
		print('Done!')
		print('')

		print('Setting and funding balances')
		set_balances(contract_instances, accounts, max_users_count)
		print('Done! Balances have been created for the stakeholders and {} users'.format(max_users_count))
		print('ArtefHack received 2500 tokens, the Advertiser received 50000 tokens, and each user received 50 tokens')
		print('')


	print('')
	print('\033[1mStarting the simulation...\033[0m')
	print('Target : {} days'.format(days_count))
	print('')

	visits, satisfied_visits, ad_views = [0] * 3
	for i in range(0, days_count):

		print('Day {}'.format(i+1))
		d_visits, s_visits, d_views, users_involved = one_day(
			contract_instances,
			accounts,
			current_users,
			users,
			users_involved,
			current_contents,
			contents,
			users_contents_matrix
		)

		visits += d_visits
		satisfied_visits += s_visits
		ad_views += d_views

	log_results(
		visits,
		satisfied_visits,
		get_publisher_revenue(contract_instances, accounts[2]),
		ad_views
	)

if __name__ == '__main__':
	run()
