# jobsub-test
## Scientific Linux containers for unit testing and linting the jobsub project

## Example Use Case:
<pre>

RECENT_BRANCHES=$(docker run  dbox/jobsub-test new_jobsub_branches 7)
for VER in 6 7; do
  CONTAINER=$(docker run -dit dbox/jobsub-test:sl${VER} /bin/bash)
  for BRANCH in $RECENT_BRANCHES; do
    BRANCH_DIR=$(echo $BRANCH | sed -e 's/\//_/g')
    docker exec -it $CONTAINER run_jobsub_unit_tests $BRANCH
    docker exec -it $CONTAINER run_jobsub_pylint $BRANCH
    docker cp $CONTAINER:/test_dir/$BRANCH_DIR $BRANCH_DIR.sl${VER}
  done
  docker stop $CONTAINER
done
</pre>

## Example Build:
<pre>
export rel=7; docker build jobsub-test --build-arg rel=$rel --tag $(whoami)/jobsub-test:latest
export rel=7; docker build jobsub-test --build-arg rel=$rel --tag $(whoami)/jobsub-test:sl${rel}
export rel=6; docker build jobsub-test --build-arg rel=$rel --tag $(whoami)/jobsub-test:sl${rel}
</pre>




