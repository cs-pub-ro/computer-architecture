# Download base image Fedora 42
FROM fedora:42

# LABEL about the custom image
LABEL maintainer="stefan_dan.ciocirlan@upb.ro"
LABEL version="0.1"
LABEL description="This is a custom Docker Image for QKD NET"

# timezone
ENV TZ=Europe/Bucharest

# Update Fedora Software repository and install necessary packages
RUN dnf update -y
RUN dnf install -y \
    gawk \
    git
RUN dnf install -y \
    latexmk \
    python3 \
    python3-pip \
    python3-sphinx \
    graphviz \
    pandoc \
    python3-poetry \
    java-21-openjdk \
    make \
    cmake
RUN pip3 install Pygments \
    pydata_sphinx_theme \
    sphinx-autodoc-typehints \
    sphinx-autoapi \
    sphinxcontrib-autoprogram \
    twine \
    matplotlib
RUN dnf install -y \
    poetry
RUN dnf install -y \
    texlive-scheme-full

# RUN poetry config virtualenvs.create false
# Setup the user sdcioc for the env
ARG USER_ID=1000
ARG GROUP_ID=1000
ARG USER_NAME=sdcioc
ARG GROUP_NAME=sdcioc

# Create a user and group with the specified IDs and names
# This is necessary to avoid permission issues when running the container
# as a non-root user, especially when using volumes
# that are mounted from the host system.
# The user will have a home directory at /home/container-user
RUN groupadd -g $GROUP_ID $GROUP_NAME && \
    useradd -m -u $USER_ID -g $GROUP_NAME $USER_NAME && \
    passwd -d $USER_NAME && \
    chown -R $USER_NAME:$GROUP_NAME /home/$USER_NAME


# # # Ensure /home/container-user is owned by container-user
RUN mkdir -p /home/$USER_NAME/.vscode-server && \
    chown -R $USER_NAME:$GROUP_NAME /home/$USER_NAME
# # # make the workspace folder in the home directory
# RUN mkdir -p /home/$USER_NAME/workspace && \
#     chown -R $USER_NAME:$GROUP_NAME /home/$USER_NAME/workspace
# # Set the working directory to the user's home directory
# WORKDIR /home/$USER_NAME/workspace
# # Set the user to the one we created
RUN dnf install -y sudo && \
    echo "$USER_NAME ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
USER $USER_NAME

# RUN poetry config virtualenvs.create false
