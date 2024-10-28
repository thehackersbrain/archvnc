FROM archlinux:latest

ENV LANG=en_US.UTF-8
ENV TERM=xterm-256color

RUN pacman -Syu --noconfirm && \
                pacman -S --noconfirm \
                base base-devel bash zsh vim sudo python-pipx git curl wget openssh tmux networkmanager xfce4 xfce4-goodies tigervnc --needed && \
                systemctl enable NetworkManager.service && \
                pacman -Scc --noconfirm && \
                rm -rf /var/cache/pacman/pkg/*

RUN curl -O https://blackarch.org/strap.sh && \
                chmod +x strap.sh && \
                ./strap.sh && \
                rm strap.sh

RUN echo 'en_US UTF-8' >> /etc/locale.gen
RUN locale-gen
RUN echo "LANG=en_US.UTF-8" > /etc/locale.conf

RUN useradd -m elliot && echo "elliot:elliot" | chpasswd && \
                echo "elliot ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers.d/elliot && \
                chmod 0440 /etc/sudoers.d/elliot

USER elliot
WORKDIR /home/elliot

RUN cd /home/elliot && \
                git clone https://aur.archlinux.org/yay.git && \
                cd yay && \
                makepkg -si --noconfirm && \
                cd .. && \
                rm -rf yay

RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
RUN git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
RUN git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
# RUN omz plugin enable z zsh-autosuggestions zsh-syntax-highlighting

RUN touch /home/elliot/.Xauthority
RUN mkdir -p /home/elliot/.config/tigervnc
COPY config /home/elliot/.config/tigervnc/config

SHELL ["/bin/zsh", "-c"]

CMD ["/bin/zsh"]
