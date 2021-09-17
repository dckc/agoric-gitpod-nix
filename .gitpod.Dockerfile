FROM gitpod/workspace-base

USER gitpod

# install nvm
RUN echo $HOME && curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | NVM_DIR=$HOME/.nvm bash \
  && chmod +x $HOME/.nvm/nvm.sh \
  && ln -s $HOME/.nvm/nvm.sh $HOME/.bashrc.d/nvm.sh
RUN . $HOME/.nvm/nvm.sh && command -v nvm

# Install node (LTS version)
# ISSUE: why isn't NVM_DIR set right???
ENV NVM_DIR=$HOME/.nvm
RUN . $HOME/.nvm/nvm.sh && env && nvm install --lts

# Install yarn
RUN . $HOME/.nvm/nvm.sh && nvm use --lts && npm install -g yarn

RUN mkdir -p $HOME/bin
ENV PATH="$HOME/bin:$PATH"

# Install Agoric SDK
RUN pwd
# TODO: go back to master when https://github.com/Agoric/agoric-sdk/pull/3838 lands
RUN git clone -b mfig-ignore-solo-web-origin https://github.com/Agoric/agoric-sdk
RUN cd agoric-sdk \
    && . $HOME/.nvm/nvm.sh && nvm use --lts \
    && yarn install && yarn build \
    && yarn link-cli ~/bin/agoric

USER root
