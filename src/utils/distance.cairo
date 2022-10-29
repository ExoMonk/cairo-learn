%lang starknet

from starkware.cairo.common.math import sqrt
from src.utils.maths import sum_of_squared_diff


func euclidian{range_check_ptr}(point_a_len: felt, point_a: felt*, point_b_len: felt, point_b: felt*) -> (_distance: felt) {
    //Euclidean distance between a & b.
    //Point has dimensions (m,), b has dimensions (n,m), and output will be of size (n,).
    //Assumptions: 0 <= a or b < 2**250
    let (_sum_diff) = sum_of_squared_diff(point_a_len, point_a, point_b_len, point_b);
    let _distance = sqrt(_sum_diff);
    return (_distance,);
}

func levenstein(a: felt, b: felt) -> () {

    return ();
}
