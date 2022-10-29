%lang starknet
from starkware.cairo.common.math import assert_nn
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.alloc import alloc

from src.utils.distance import euclidian
from src.utils.maths import map_struct
from src.utils.arrays import get_first_element_at, get_second_element_at, min, max
from src.utils.models import Matrix, Point

@storage_var
func n_clusters() -> (_n_clusters: felt) {
}

@storage_var
func max_iter() -> (_max_iter: felt) {
}

@storage_var
func centroids(centroid_index: felt) -> (_centroid: Point) {
}


namespace KMeans {

    func initialize(_n_cluster: felt, _max_iter: felt) {
        n_clusters.write(_n_cluster);
        max_iter.write(_max_iter);
    }
    
    func fit{range_check_ptr}(x_train_len: felt, x_train: Matrix*) {
        alloc_locals;
        let (local array_a: felt*) = map_struct(get_first_element_at, x_train_len, x_train, Matrix.SIZE);
        let (local array_b: felt*) = map_struct(get_second_element_at, x_train_len, x_train, Matrix.SIZE);
        let _min_a = min(x_train_len, array_a);
        let _min_b = min(x_train_len, array_b);
        let _max_a = max(x_train_len, array_a);
        let _max_b = max(x_train_len, array_b);
        let (local _min: felt*) = alloc();
        let (local _max: felt*) = alloc();
        assert _min[0] = _min_a;
        assert _min[1] = _min_b;
        assert _max[0] = _max_a;
        assert _max[1] = _max_b;



        //self.centroids = [uniform(min_, max_) for _ in range(self.n_clusters)]


        let iteration = 0;
    }

    func setup_centroids() {

        centroids.write(1, 1);

    }

    func evaluate(x_train: felt*) {

    }
}

