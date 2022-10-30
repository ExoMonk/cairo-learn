%lang starknet
from src.utils.arrays import add_last, get_array_axis
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.alloc import alloc

@external
func test_increase_balance{syscall_ptr: felt*, range_check_ptr, pedersen_ptr: HashBuiltin*}() {

    alloc_locals;
    let (local arr: felt*) = alloc();
    let len = 1;
    assert arr[0] = 5;

    let (fin_arr_len, fin_arr) = add_last(len, arr, 9);

    assert fin_arr_len = 2;
    return ();
}
