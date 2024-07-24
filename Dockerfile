FROM rocker/r-devel
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get clean
RUN apt-get install terminator tree eza ssh zsh git fzf ripgrep vim curl \
autojump  zsh-autosuggestions sudo pandoc -y
RUN Rscript -e 'install.packages("renv")'
COPY renv.lock renv.lock
RUN  Rscript -e 'renv::restore()'
RUN groupadd --system joe
RUN useradd --system --gid joe -m joe
RUN usermod -aG sudo joe
RUN echo joe:z | chpasswd
RUN chown joe:joe -R /home/joe
RUN chown joe:joe -R /usr/local/lib/R/site-library
RUN chsh -s $(which zsh) joe
WORKDIR /home/joe/
COPY .vimrc .vimrc
COPY .zshrc .zshrc
RUN chown joe:joe -R /home/joe
RUN mkdir -p  /home/joe/output
USER joe
RUN curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
CMD ["/bin/zsh"]
