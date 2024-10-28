FROM archlinux:latest

ENV LANG=en_US.UTF-8
ENV TERM=xterm-256color

RUN pacman -Syu --noconfirm && \
                pacman -S --noconfirm \
                base base-devel bash zsh vim firefox sudo python-pipx terminus-font pango git curl wget openssh tmux networkmanager xfce4 xfce4-goodies tigervnc --needed && \
                systemctl enable NetworkManager.service && \
                pacman -Scc --noconfirm && \
                rm -rf /var/cache/pacman/pkg/*

RUN curl -O https://blackarch.org/strap.sh && \
                chmod +x strap.sh && \
                ./strap.sh && \
                rm strap.sh

RUN pacman -S --noconfirm burpsuite nmap

RUN echo 'en_US UTF-8' >> /etc/locale.gen
RUN locale-gen
RUN echo "LANG=en_US.UTF-8" > /etc/locale.conf

RUN useradd -m naruto && echo "naruto:naruto" | chpasswd && \
                echo "naruto ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers.d/naruto && \
                chmod 0440 /etc/sudoers.d/naruto

RUN chsh -s /usr/bin/zsh naruto

USER naruto
WORKDIR /home/naruto

RUN cd /home/naruto && \
                git clone https://aur.archlinux.org/yay.git && \
                cd yay && \
                makepkg -si --noconfirm && \
                cd .. && \
                rm -rf yay

RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
RUN git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
RUN git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
RUN git clone https://github.com/tmux-plugins/tpm /home/naruto/.tmux/plugins/tpm

RUN touch /home/naruto/.Xauthority
RUN mkdir -p /home/naruto/.config/tigervnc
COPY passwd /home/naruto/.config/tigervnc/passwd
COPY config /home/naruto/.config/tigervnc/config
RUN sudo chown naruto:naruto -R /home/naruto/.config/tigervnc
RUN chmod 600 /home/naruto/.config/tigervnc/passwd
RUN sed -i 's/^ZSH_THEME="robbyrussell"/ZSH_THEME="gentoo"/' /home/naruto/.zshrc
RUN sed -i 's/^plugins=(git)/plugins=(git z zsh-syntax-highlighting zsh-autosuggestions)/' /home/naruto/.zshrc
COPY vimrc /home/naruto/.vimrc
COPY tmux.conf /home/naruto/.tmux.conf

SHELL ["/bin/zsh", "-c"]
CMD ["/bin/zsh"]
