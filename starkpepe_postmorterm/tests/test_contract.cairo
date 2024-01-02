
use snforge_std::{start_prank, CheatTarget, PrintTrait};

use starknet::{ContractAddress, Felt252TryIntoContractAddress};


#[starknet::interface]
trait IERC20<TState> {
    fn balance_of(self: @TState, account: ContractAddress) -> u256;
    fn transfer(ref self: TState, recipient: ContractAddress, amount: u256) -> bool;
   
}

#[test]
#[fork("stark_fork")]
fn test_using_forked_state() {
    let attacker: ContractAddress = 0x0770b2ce26f4b3a1c39c95f3e34c2660fa723967b3adbdce769de44f37dd9283.try_into().unwrap();
    let contract_address: ContractAddress = 0x06f15ec4b6ff0b7f7a216c4b2ccdefc96cbf114d6242292ca82971592f62273b.try_into().unwrap();
    let erc20_dispatcher = IERC20Dispatcher {contract_address};
    let balance = erc20_dispatcher.balance_of(attacker);
    balance.print();
    start_prank(CheatTarget::One(contract_address), attacker);
    erc20_dispatcher.transfer(0x0770b2ce26f4b3a1c39c95f3e34c2660fa723967b3adbdce769de44f37dd9283.try_into().unwrap(), balance);
    let new_balance = erc20_dispatcher.balance_of(0x0770b2ce26f4b3a1c39c95f3e34c2660fa723967b3adbdce769de44f37dd9283.try_into().unwrap());
    new_balance.print();
}

