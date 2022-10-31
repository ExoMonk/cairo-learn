%lang starknet
from starkware.cairo.common.math import assert_nn
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.alloc import alloc

from src.utils.distance import euclidian
from src.utils.models import Matrix, Point

@storage_var
func n_clusters() -> (_n_clusters: felt){
}

@storage_var
func max_iter() -> (_max_iter: felt){
}

@storage_var
func centroids(centroid_index: felt) -> (_centroid: Point){
}


namespace KMeans {

    func initialize(_n_cluster: felt, _max_iter: felt){
        n_clusters.write(_n_cluster);
        max_iter.write(_max_iter);
    }
    
    func fit{range_check_ptr}(x_train_len: felt, x_train: Matrix*){
        let _n_clusters = n_clusters.read();
        setup_centroids(0, _n_clusters, x_train);
        let iteration = 0;
        let prev_centroids = 0;
        step(iteration, prev_centroids, x_train_len, x_train);
    }

    func setup_centroids(centroid_index: felt, _n_clusters: felt, x_train: Matrix*){
        if (centroid_index + 1 == _n_clusters) {
            return ();
        }
        let point = x_train[centroid_index];
        let centroid = new Point(x=point.array[0], y=point.array[1]);
        centroids.write(centroid_index, centroid);
        setup_centroids(centroid_index + 1, _n_clusters, x_train);
        return ();
    }

    func step(iteration: felt, prev_centroids: Point*, x_train_len: felt, x_train: Matrix*){
        // Step of a centroid
        let _max_iter = max_iter.read();
        if (iteration == _max_iter) {
            //Ending Algorithm reached maximum iterations.
            return ();
        }
        alloc_locals;
        let _n_cluster = n_clusters.read();
        let (local centroids: Point*) = alloc();
        get_centroids(0, _n_cluster, centroids);
        if (prev_centroids == _centroids) {
            //Ending algorithm convergence reached.
            return ();
        }
        let start_index = 0;
        loop_data(start_index, x_train_len, x_train);
    }

    func loop_data(current_index: felt, x_train_len: felt, x_train: Matrix*){
        if (current_index == x_train_len) {
            return ();
        }
        alloc_locals;
        let current_point = x_train[current_index].array;
        let current_point_len = x_train[current_index].array_len;
        let cluster_index = 0;
        let (local distances: felt*) = alloc();
        distance_to_centroid(current_point_len, current_point, cluster_index, 0, distances);
        
        
        //centroid_idx = np.argmin(dists)
        //sorted_points[centroid_idx].append(x)

    }

    func distance_to_centroid(point_len: felt, point: felt, centroid_index: felt, distances_len: felt, distances: felt){
        let _n_cluster = n_clusters.read();
        if (centroid_index == _n_cluster) {
            return ();
        }
        alloc_locals;
        let current_centroid = centroids.read(centroid_index);
        let (local centroid: felt*) = alloc();
        assert centroid[0] = current_centroid.x;
        assert centroid[1] = current_centroid.y;
        let (_distance: felt) = euclidian(point_len, point, 2, centroid);
        assert distances[distances_len] = _distance;
        distance_to_centroid(point_len, point, centroid_index + 1, distances_len + 1, distances);
    }

    func evaluate(x_train: felt*){

    }

    func get_centroids(current_index: felt, _n_cluster: felt, centroids: Point*) -> (){
        if (current_index == _n_cluster) {
            return();
        }
        let current_point = centroids.read(current_index);
        assert centroids[current_index] = current_point;
        get_centroids(current_index + 1, _n_cluster, centroids);
    }

    func is_converging() -> (_is_converging: felt){


    }
}

