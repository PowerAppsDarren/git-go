# Git-Go Data Flow Diagrams

## Configuration Data Flow

```mermaid
graph TB
    subgraph "Configuration Loading"
        Start[Script Start]
        CheckConfig{Config exists?}
        CreateConfig[Create default config]
        LoadConfig[Source config file]
        ApplyDefaults[Apply defaults]
        OverrideEnv[Override with env vars]
    end
    
    subgraph "Configuration Usage"
        NewCmd[new command]
        ForkCmd[fork command]
        SyncGen[Sync script generation]
        RemoteSetup[Remote setup]
    end
    
    Start --> CheckConfig
    CheckConfig -->|No| CreateConfig
    CheckConfig -->|Yes| LoadConfig
    CreateConfig --> LoadConfig
    LoadConfig --> ApplyDefaults
    ApplyDefaults --> OverrideEnv
    OverrideEnv --> NewCmd
    OverrideEnv --> ForkCmd
    OverrideEnv --> SyncGen
    OverrideEnv --> RemoteSetup
```

## Repository Metadata Flow

```mermaid
graph LR
    subgraph "Input Sources"
        UserInput[User Input]
        GitURL[Git URL]
        LocalFS[Local Filesystem]
    end
    
    subgraph "Metadata Extraction"
        ParseName[Parse Repo Name]
        ValidateName[Validate Name]
        ExtractOrg[Extract Organization]
        DetectType[Detect Repo Type]
    end
    
    subgraph "Metadata Storage"
        RepoName[Repository Name]
        RepoType[Repository Type]
        UpstreamURL[Upstream URL]
        RemoteURLs[Remote URLs]
    end
    
    subgraph "File Generation"
        Templates[Template Engine]
        OutputFiles[Generated Files]
    end
    
    UserInput --> ParseName
    GitURL --> ParseName
    LocalFS --> DetectType
    
    ParseName --> ValidateName
    ValidateName --> RepoName
    ParseName --> ExtractOrg
    ExtractOrg --> RemoteURLs
    DetectType --> RepoType
    GitURL --> UpstreamURL
    
    RepoName --> Templates
    RepoType --> Templates
    UpstreamURL --> Templates
    RemoteURLs --> Templates
    
    Templates --> OutputFiles
```

## Git Operations Sequence

```mermaid
sequenceDiagram
    participant User
    participant GitGo as git-go
    participant Config
    participant Git
    participant Remote as Git Remotes
    participant VSCode
    
    User->>GitGo: git-go new --name myrepo
    GitGo->>Config: Load configuration
    Config-->>GitGo: Return config values
    
    GitGo->>Git: git init
    Git-->>GitGo: Repository initialized
    
    GitGo->>GitGo: Generate files
    GitGo->>Git: git add .
    GitGo->>Git: git commit -m "Initial commit"
    
    GitGo->>Git: git remote add origin1
    GitGo->>Git: git remote add origin2
    
    GitGo->>Remote: git push origin1
    GitGo->>Remote: git push origin2
    
    GitGo->>VSCode: code .
    VSCode-->>User: Opens in VS Code
```

## Fork Workflow Sequence

```mermaid
sequenceDiagram
    participant User
    participant GitGo as git-go
    participant Upstream
    participant Fork as User's Fork
    participant Local
    
    User->>GitGo: git-go fork --url upstream-url
    GitGo->>Upstream: git clone upstream-url
    Upstream-->>Local: Repository cloned
    
    GitGo->>Local: git remote rename origin upstream
    GitGo->>Local: git remote add origin1 fork-url1
    GitGo->>Local: git remote add origin2 fork-url2
    
    GitGo->>Local: Generate sync script
    GitGo->>Local: git add & commit
    
    GitGo->>Fork: git push origin1
    GitGo->>Fork: git push origin2
    
    Note over Local: Future syncs
    User->>Local: ./scripts/sync.sh
    Local->>Upstream: git fetch upstream
    Local->>Local: git merge upstream/main
    Local->>Fork: git push all remotes
```

## Sync Script Execution Flow

```mermaid
stateDiagram-v2
    [*] --> CheckStatus: Start sync
    
    CheckStatus --> StashChanges: Has uncommitted changes
    CheckStatus --> CheckFork: No changes
    
    StashChanges --> CheckFork: Changes stashed
    
    CheckFork --> FetchUpstream: Is fork
    CheckFork --> PullOrigin: Not fork
    
    FetchUpstream --> MergeUpstream: Fetched
    MergeUpstream --> PullOrigin: Merged
    
    PullOrigin --> RestoreStash: Pulled
    
    RestoreStash --> ApplyStash: Had stash
    RestoreStash --> PushRemotes: No stash
    
    ApplyStash --> PushRemotes: Stash applied
    
    PushRemotes --> ShowStatus: Pushed
    ShowStatus --> [*]: Complete
```

## Error Recovery Flow

```mermaid
flowchart TD
    subgraph "Error Detection"
        Operation[Git Operation]
        CheckExit{Exit code = 0?}
        IdentifyError[Identify Error Type]
    end
    
    subgraph "Error Types"
        NetworkError[Network Error]
        AuthError[Auth Error]
        MergeError[Merge Conflict]
        PermError[Permission Error]
        UnknownError[Unknown Error]
    end
    
    subgraph "Recovery Actions"
        RetryOp[Retry Operation]
        PromptAuth[Prompt for Auth]
        ShowConflicts[Show Conflicts]
        FixPerms[Suggest Fix]
        ShowHelp[Show Error Help]
    end
    
    subgraph "Resolution"
        Resolved[Continue]
        UserAction[Request User Action]
        Abort[Abort Operation]
    end
    
    Operation --> CheckExit
    CheckExit -->|No| IdentifyError
    CheckExit -->|Yes| Resolved
    
    IdentifyError --> NetworkError
    IdentifyError --> AuthError
    IdentifyError --> MergeError
    IdentifyError --> PermError
    IdentifyError --> UnknownError
    
    NetworkError --> RetryOp
    AuthError --> PromptAuth
    MergeError --> ShowConflicts
    PermError --> FixPerms
    UnknownError --> ShowHelp
    
    RetryOp --> Operation
    PromptAuth --> UserAction
    ShowConflicts --> UserAction
    FixPerms --> UserAction
    ShowHelp --> Abort
```

## Template Processing Pipeline

```mermaid
graph TD
    subgraph "Template Input"
        Template[Template String]
        Variables[Variable Map]
        Conditions[Conditional Flags]
    end
    
    subgraph "Processing Steps"
        Parse[Parse Template]
        Replace[Replace Variables]
        Evaluate[Evaluate Conditions]
        Format[Format Output]
        Validate[Validate Result]
    end
    
    subgraph "Variable Sources"
        Config[Configuration]
        Runtime[Runtime Values]
        Computed[Computed Values]
    end
    
    subgraph "Output"
        Generated[Generated File]
        Error[Error Message]
    end
    
    Template --> Parse
    Variables --> Replace
    Conditions --> Evaluate
    
    Config --> Variables
    Runtime --> Variables
    Computed --> Variables
    
    Parse --> Replace
    Replace --> Evaluate
    Evaluate --> Format
    Format --> Validate
    
    Validate -->|Valid| Generated
    Validate -->|Invalid| Error
```

## Multi-Remote Push Strategy

```mermaid
graph TB
    subgraph "Push Initiation"
        Start[Start Push]
        GetRemotes[Get Remote List]
        FilterRemotes[Filter Active Remotes]
    end
    
    subgraph "Push Execution"
        Remote1[Push to origin1]
        Remote2[Push to origin2]
        RemoteN[Push to origin-n]
    end
    
    subgraph "Error Handling"
        Success1[origin1 ✓]
        Success2[origin2 ✓]
        Failed[origin-n ✗]
        Retry[Retry Failed]
    end
    
    subgraph "Completion"
        Report[Status Report]
        Summary[Push Summary]
    end
    
    Start --> GetRemotes
    GetRemotes --> FilterRemotes
    
    FilterRemotes --> Remote1
    FilterRemotes --> Remote2
    FilterRemotes --> RemoteN
    
    Remote1 -->|Success| Success1
    Remote2 -->|Success| Success2
    RemoteN -->|Failed| Failed
    
    Failed --> Retry
    Retry -->|Success| Success2
    Retry -->|Failed| Report
    
    Success1 --> Report
    Success2 --> Report
    
    Report --> Summary
```