%lang starknet

from starkware.cairo.common.pow import pow
from starkware.cairo.common.registers import get_label_location
from starkware.cairo.common.registers import get_ap
from starkware.cairo.common.invoke import invoke
from starkware.cairo.common.memcpy import memcpy
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.alloc import alloc

from src.utils.arrays import append_element


func sum_of_squared_diff{range_check_ptr}(point_a_len: felt, point_a: felt*, point_b_len: felt, point_b: felt*) -> (_sum_diff: felt) {
    alloc_locals;
    if (point_a_len == 0) {
        return (0,);
    }

    let value_a = point_a[0];
    let value_b = point_b[0];
    let diff = value_a - value_b;
    let (sum_of_rest) = sum_of_squared_diff(point_a_len=point_a_len - 1, point_a=point_a + 1, point_b_len=point_b_len - 1, point_b=point_b + 1);
    let (_squared_diff) = pow(diff, 2);
    let res = _squared_diff + sum_of_rest;
    return (_sum_diff=res);
}

func prepare_argument(argument_pointer: felt*, argument_size: felt) -> (argument: felt) {
    if (argument_size == 1) {
        return (argument=[argument_pointer]);
    }

    return (argument=cast(argument_pointer, felt));
}

func map_loop(
    func_pc: felt*,
    array_len: felt,
    array: felt*,
    element_size: felt,
    implicit_args_len: felt,
    implicit_args: felt*,
    new_array: felt*,
) -> (implicit_args: felt*) {
    alloc_locals;

    if (array_len == 0) {
        return (implicit_args,);
    }

    // Build arguments array
    let (args_len: felt, args: felt*) = prepare_arguments(
        array, element_size, implicit_args_len, implicit_args
    );

    // Call the function
    invoke(func_pc, args_len, args);

    // Retrieve results
    let (ap_val) = get_ap();
    let implicit_args: felt* = cast(ap_val - implicit_args_len - 1, felt*);

    append_element(new_array, [ap_val - 1], element_size);

    // Process next element
    return map_loop(
        func_pc,
        array_len - 1,
        array + element_size,
        element_size,
        implicit_args_len,
        implicit_args,
        new_array + element_size,
    );
}

func prepare_arguments(
    array: felt*, element_size: felt, implicit_args_len: felt, implicit_args: felt*
) -> (args_len: felt, args: felt*) {
    alloc_locals;

    let (arg_next_element) = prepare_argument(array, element_size);

    let (local args: felt*) = alloc();
    memcpy(args, implicit_args, implicit_args_len);
    assert args[implicit_args_len] = arg_next_element;

    return (implicit_args_len + 1, args);
}

func map(
    function: codeoffset,
    array_len: felt,
    array: felt*,
    element_size: felt,
    implicit_args_len: felt,
    implicit_args: felt*,
) -> (mapped_array: felt*, implicit_args: felt*) {
    alloc_locals;
    let (local func_pc) = get_label_location(function);
    let (mapped_array: felt*) = alloc();
    let (implicit_args: felt*) = map_loop(
        func_pc, array_len, array, element_size, implicit_args_len, implicit_args, mapped_array
    );
    return (mapped_array, implicit_args);
}

func map_struct{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    function: codeoffset, array_len: felt, array: felt*, element_size: felt
) -> (mapped_array: felt*) {
    let implicit_args_len = map_struct.ImplicitArgs.SIZE;
    tempvar implicit_args = new map_struct.ImplicitArgs(syscall_ptr, pedersen_ptr, range_check_ptr);

    let (mapped_array: felt*, updated_implicit_args: felt*) = map(
        function, array_len, array, element_size, implicit_args_len, implicit_args
    );

    let implicit_args = cast(updated_implicit_args, map_struct.ImplicitArgs*);
    let syscall_ptr = implicit_args.syscall_ptr;
    let pedersen_ptr = implicit_args.pedersen_ptr;
    let range_check_ptr = implicit_args.range_check_ptr;

    return (mapped_array,);
}
