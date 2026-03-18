
#[derive(clap::ValueEnum, Debug, Clone)]
pub enum Shell{
    Bash,
    Fish,
    Zsh,
    Nushell,
    Posix
}


impl Shell{
    pub fn init(self){
        match self{
            Self::Bash => println!("{}",include_str!("shells/pm.bash")),
            Self::Zsh => println!("{}",include_str!("shells/pm.zsh")),
            Self::Nushell => println!("{}",include_str!("shells/pm.nu")),
            _ => println!("uninmplemented")
            
        }
    }
}
