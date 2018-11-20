ARG rel=7
FROM scientificlinux/sl:${rel}
ARG rel
ENV rel ${rel} 

#the test/lint remote commands
RUN mkdir -p jobsub_test/output
COPY run_unit_tests /usr/local/bin/run_jobsub_coverage
COPY quick_tests /usr/local/bin/jobsub_quick_tests
COPY slow_tests /jobsub_test/slow_test_list
COPY help       /usr/local/bin/help
COPY run_pylint /usr/local/bin/run_jobsub_pylint
COPY new_branches /usr/local/bin/new_jobsub_branches
COPY jenkins_scripts jobsub_test/jenkins_scripts

RUN rpm -Uvh https://repo.opensciencegrid.org/osg/3.4/osg-3.4-el${rel}-release-latest.rpm
RUN yum -y -q update &&  yum -y -q install osg-ca-certs
RUN yum -y -q install findutils
RUN yum -y -q install which
RUN yum -y -q install file
RUN yum -y -q install git

# set up code repo
RUN cd jobsub_test && git clone https://github.com/ddbox/jobsub.git
RUN cd jobsub_test && source jobsub/test/scripts/utils.sh && setup_python_venv

#clean up
RUN cd jobsub_test && rm -rf virtualenv-*

# env vars needed by unit test scripts
RUN cd /root && echo ". /jobsub_test/venv-2.${rel}/bin/activate" >> .bashrc
ENV VIRTUAL_ENV=/jobsub_test/venv-2.${rel}
ENV PYTHONPATH=/jobsub_test

