%lang starknet

from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.memcpy import memcpy
from starkware.cairo.common.math_cmp import is_le, is_not_zero
from starkware.cairo.common.bool import TRUE

from src.utils.models import Matrix


func get_first_element_at(matrix: Matrix) -> (value: felt) {
    let value = matrix.array[0];
    return (value,);
}

func get_second_element_at(matrix: Matrix) -> (value: felt) {
    let value = matrix.array[1];
    return (value,);
}

func index_of_min{range_check_ptr}(arr_len: felt, arr: felt*) -> (index: felt) {
    assert_check_array_not_empty(arr_len);
    return index_of_min_recursive(arr_len, arr, arr[0], 0, 1);
}

func index_of_min_recursive{range_check_ptr}(arr_len: felt, arr: felt*, current_min: felt, current_min_index: felt, current_index: felt) -> (index: felt) {
    if (arr_len == current_index) {
        return (current_min_index,);
    }
    let is_less = is_le(arr[current_index], current_min);
    if (is_less == TRUE) {
        return index_of_min_recursive(
            arr_len, arr, arr[current_index], current_index, current_index + 1
        );
    }
    return index_of_min_recursive(arr_len, arr, current_min, current_min_index, current_index + 1);
}

func index_of_max{range_check_ptr}(arr_len: felt, arr: felt*) -> (index: felt) {
    assert_check_array_not_empty(arr_len);
    return index_of_max_recursive(arr_len, arr, arr[0], 0, 1);
}

func index_of_max_recursive{range_check_ptr}(arr_len: felt, arr: felt*, current_max: felt, current_max_index: felt, current_index: felt) -> (index: felt) {
    if (arr_len == current_index) {
        return (current_max_index,);
    }
    let is_less = is_le(current_max, arr[current_index]);
    if (is_less == TRUE) {
        return index_of_max_recursive(
            arr_len, arr, arr[current_index], current_index, current_index + 1
        );
    }
    return index_of_max_recursive(arr_len, arr, current_max, current_max_index, current_index + 1);
}

func assert_check_array_not_empty(arr_len: felt) {
    let res = is_not_zero(arr_len);
    with_attr error_message("Empty array") {
        assert res = TRUE;
    }
    return ();
}

func append_element(array: felt*, element: felt, element_size: felt) {
    if (element_size == 1) {
        [array] = element;
    } else {
        memcpy(array, cast(element, felt*), element_size);
    }
    return ();
}

func min{range_check_ptr}(array_len: felt, array: felt*) -> (value: felt) {
    let (_index_of_min) = index_of_min(array_len, array);
    return (array[_index_of_min],);
}

func max{range_check_ptr}(array_len: felt, array: felt*) -> (value: felt) {
    let (_index_of_max) = index_of_max(array_len, array);
    return (array[_index_of_max],);
}
