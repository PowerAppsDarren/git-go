# Git-Go Architecture Diagrams

## System Architecture

```mermaid
graph TB
    subgraph "User Interface"
        CLI[git-go CLI]
        Args[Command Args]
        Interactive[Interactive Mode]
    end
    
    subgraph "Core Components"
        Main[bin/git-go]
        Colors[lib/colors.sh]
        GitUtils[lib/git-utils.sh]
        Config[~/.config/git-go/config]
    end
    
    subgraph "Commands"
        New[new command]
        Fork[fork command]
        ConfigCmd[config command]
        Help[help command]
    end
    
    subgraph "Generated Files"
        SyncScript[scripts/sync.sh]
        VSCode[.vscode/tasks.json]
        Claude[CLAUDE.md]
        GitIgnore[.gitignore]
        Readme[README.md]
    end
    
    CLI --> Main
    Args --> Main
    Interactive --> Main
    Main --> Colors
    Main --> GitUtils
    Main --> Config
    Main --> New
    Main --> Fork
    Main --> ConfigCmd
    Main --> Help
    New --> SyncScript
    New --> VSCode
    New --> Claude
    New --> GitIgnore
    New --> Readme
    Fork --> SyncScript
    Fork --> VSCode
    Fork --> Claude
```

## Command Flow: `git-go new`

```mermaid
flowchart TD
    Start([User runs git-go new])
    ParseArgs{Parse Arguments}
    CheckName{Name provided?}
    PromptName[Prompt for name]
    ValidateName{Validate name}
    CheckExists{Repo exists?}
    CreateDir[Create directory]
    InitGit[Initialize git]
    CreateFiles[Generate files]
    AddCommit[Add and commit]
    CreateRemotes{Remotes configured?}
    AddRemotes[Add git remotes]
    FirstPush[Push to remotes]
    OpenVSCode{VS Code configured?}
    LaunchVSCode[Launch VS Code]
    End([Repository ready])
    
    Start --> ParseArgs
    ParseArgs --> CheckName
    CheckName -->|No| PromptName
    CheckName -->|Yes| ValidateName
    PromptName --> ValidateName
    ValidateName -->|Invalid| PromptName
    ValidateName -->|Valid| CheckExists
    CheckExists -->|Yes| PromptName
    CheckExists -->|No| CreateDir
    CreateDir --> InitGit
    InitGit --> CreateFiles
    CreateFiles --> AddCommit
    AddCommit --> CreateRemotes
    CreateRemotes -->|Yes| AddRemotes
    CreateRemotes -->|No| OpenVSCode
    AddRemotes --> FirstPush
    FirstPush --> OpenVSCode
    OpenVSCode -->|Yes| LaunchVSCode
    OpenVSCode -->|No| End
    LaunchVSCode --> End
```

## Command Flow: `git-go fork`

```mermaid
flowchart TD
    Start([User runs git-go fork])
    ParseArgs{Parse Arguments}
    CheckURL{URL provided?}
    PromptURL[Prompt for URL]
    ExtractName[Extract repo name]
    CheckExists{Repo exists?}
    CloneRepo[Clone repository]
    AddUpstream[Add upstream remote]
    CreateFiles[Generate sync files]
    UpdateFiles[Update existing files]
    CommitChanges[Commit changes]
    CreateRemotes{Own remotes configured?}
    AddRemotes[Add personal remotes]
    PushChanges[Push to remotes]
    OpenVSCode{VS Code configured?}
    LaunchVSCode[Launch VS Code]
    End([Fork ready])
    
    Start --> ParseArgs
    ParseArgs --> CheckURL
    CheckURL -->|No| PromptURL
    CheckURL -->|Yes| ExtractName
    PromptURL --> ExtractName
    ExtractName --> CheckExists
    CheckExists -->|Yes| PromptURL
    CheckExists -->|No| CloneRepo
    CloneRepo --> AddUpstream
    AddUpstream --> CreateFiles
    CreateFiles --> UpdateFiles
    UpdateFiles --> CommitChanges
    CommitChanges --> CreateRemotes
    CreateRemotes -->|Yes| AddRemotes
    CreateRemotes -->|No| OpenVSCode
    AddRemotes --> PushChanges
    PushChanges --> OpenVSCode
    OpenVSCode -->|Yes| LaunchVSCode
    OpenVSCode -->|No| End
    LaunchVSCode --> End
```

## Sync Script Operation

```mermaid
flowchart TD
    Start([User triggers sync])
    CheckChanges{Uncommitted changes?}
    StashChanges[Stash changes]
    CheckUpstream{Is fork?}
    FetchUpstream[Fetch upstream]
    MergeUpstream[Merge upstream/main]
    PullOrigin[Pull from origin]
    RestoreStash{Had stashed changes?}
    PopStash[Pop stash]
    PushRemotes[Push to all remotes]
    ShowStatus[Show git status]
    End([Sync complete])
    
    Start --> CheckChanges
    CheckChanges -->|Yes| StashChanges
    CheckChanges -->|No| CheckUpstream
    StashChanges --> CheckUpstream
    CheckUpstream -->|Yes| FetchUpstream
    CheckUpstream -->|No| PullOrigin
    FetchUpstream --> MergeUpstream
    MergeUpstream --> PullOrigin
    PullOrigin --> RestoreStash
    RestoreStash -->|Yes| PopStash
    RestoreStash -->|No| PushRemotes
    PopStash --> PushRemotes
    PushRemotes --> ShowStatus
    ShowStatus --> End
```

## Configuration System

```mermaid
graph LR
    subgraph "Configuration Sources"
        Default[Default Values]
        UserConfig[~/.config/git-go/config]
        EnvVars[Environment Variables]
        CLIArgs[CLI Arguments]
    end
    
    subgraph "Configuration Values"
        GitServers[Git Servers]
        VSCodePath[VS Code Path]
        Templates[File Templates]
        Features[Feature Flags]
    end
    
    Default --> GitServers
    Default --> VSCodePath
    Default --> Templates
    Default --> Features
    
    UserConfig -.override.-> GitServers
    UserConfig -.override.-> VSCodePath
    UserConfig -.override.-> Templates
    UserConfig -.override.-> Features
    
    EnvVars -.override.-> GitServers
    EnvVars -.override.-> VSCodePath
    
    CLIArgs -.override.-> GitServers
    CLIArgs -.override.-> Features
```

## File Generation Process

```mermaid
graph TD
    subgraph "Input"
        RepoType{Repository Type}
        Config[Configuration]
        RepoInfo[Repository Info]
    end
    
    subgraph "Templates"
        SyncTemplate[Sync Script Template]
        VSCodeTemplate[VS Code Tasks Template]
        ClaudeTemplate[CLAUDE.md Template]
        ReadmeTemplate[README.md Template]
    end
    
    subgraph "Processing"
        SubstituteVars[Variable Substitution]
        ConditionalLogic[Conditional Logic]
        FormatOutput[Format Output]
    end
    
    subgraph "Output Files"
        Scripts[scripts/sync.sh]
        VSCodeTasks[.vscode/tasks.json]
        ClaudeMD[CLAUDE.md]
        ReadmeMD[README.md]
        GitIgnore[.gitignore]
    end
    
    RepoType --> SubstituteVars
    Config --> SubstituteVars
    RepoInfo --> SubstituteVars
    
    SyncTemplate --> SubstituteVars
    VSCodeTemplate --> SubstituteVars
    ClaudeTemplate --> SubstituteVars
    ReadmeTemplate --> SubstituteVars
    
    SubstituteVars --> ConditionalLogic
    ConditionalLogic --> FormatOutput
    
    FormatOutput --> Scripts
    FormatOutput --> VSCodeTasks
    FormatOutput --> ClaudeMD
    FormatOutput --> ReadmeMD
    FormatOutput --> GitIgnore
```

## Deployment Process

```mermaid
flowchart TD
    Start([Run deploy.sh])
    CheckBin{~/bin exists?}
    CreateBin[Create ~/bin directory]
    RemoveOld{Old git-go exists?}
    DeleteOld[Remove old git-go]
    CreateLink[Create symlink]
    MakeExec[Ensure executable]
    TestLink[Test symlink]
    ShowVersion[Display version]
    End([Deployment complete])
    
    Start --> CheckBin
    CheckBin -->|No| CreateBin
    CheckBin -->|Yes| RemoveOld
    CreateBin --> RemoveOld
    RemoveOld -->|Yes| DeleteOld
    RemoveOld -->|No| CreateLink
    DeleteOld --> CreateLink
    CreateLink --> MakeExec
    MakeExec --> TestLink
    TestLink --> ShowVersion
    ShowVersion --> End
```

## Error Handling Flow

```mermaid
flowchart TD
    Operation[Any Operation]
    TryCatch{Try Operation}
    Success[Continue]
    Error[Error Occurred]
    ColorError[Display with red color]
    LogError[Log to stderr]
    Cleanup{Cleanup needed?}
    RunCleanup[Run cleanup]
    Exit[Exit with code]
    
    Operation --> TryCatch
    TryCatch -->|Success| Success
    TryCatch -->|Failure| Error
    Error --> ColorError
    ColorError --> LogError
    LogError --> Cleanup
    Cleanup -->|Yes| RunCleanup
    Cleanup -->|No| Exit
    RunCleanup --> Exit
```