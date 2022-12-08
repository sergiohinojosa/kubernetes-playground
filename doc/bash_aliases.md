# .bash_aliases 

### Bash and Kubectl Pro CLI aliases in .bash_aliases for the users to navigate in the terminal like butter

```bash
# Alias for ease of use of the CLI
# available in .bash_aliases

alias las='ls -las' 
alias c='clear' 
# search in History like: hg curl - to list all cUrls done
alias hg='history | grep' 
alias h='history' 
# very useful in combination with for example: kubectl get pod -o yaml | vaml 
alias vaml='vi -c \"set syntax:yaml\" -' 
# very useful in combination with for example: kubectl get pod -o json | vson 
alias vson='vi -c \"set syntax:json\" -' 
# Find processes easy
alias pg='ps -aux | grep'
```


