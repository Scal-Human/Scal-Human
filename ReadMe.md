![Who am I](https://raw.githubusercontent.com/Scal-Human/Scal-Human/refs/heads/main/Documentation/Scal-Summary.svg)

Where | What
--- | ---
[BlogSpot Ex-Pression](http://scal-ex-pression.blogspot.com) | Texts (French, English)
[GitHub](https://github.com/Scal-Human?tab=repositories) | Repositories
[NuGet](https://www.nuget.org/profiles/Scal.Human) | Packages
[PowerShell Gallery](https://www.nuget.org/profiles/Scal.Human) | Modules
[SoundCloud Ex-Pression](https://soundcloud.com/ex-pression) | Tunes

## Repositories naming

The .Net libraries names, and the namespaces they contain, are unconventional and do not follow
the usual namings found in the framework because naming conventions in the framework evolved
over time and are not always consistent across components.

For instance, **System.Text.Json** is about serialization, and **System.Xml.Serialization** is handling text data.

So instead of trying to follow rules that do not exist, that change over time or that depend on the team that created the components;
I prefer being consistent and predictable so you just have the surprise once: on the first library you use.

![Repo-Naming](https://raw.githubusercontent.com/Scal-Human/Scal-Human/refs/heads/main/Documentation/Repo-Naming.svg)

A capability repository often produces two packages:
- the abstractions with interfaces and primitives (e.g. Scal.Serializing.Abstractions)
- the core implementation (e.g. Scal.Serializing)

### Examples

```
Scal.Interpreting.Commands
Scal.Serializing
Scal.Serializing.Csv
Scal.Serializing.Ini
Scal.Serializing.Json
Scal.Serializing.Json.Schemas
Scal.Serializing.Xml
Scal.Storing.Documents.LiteDB
```

### Exceptions

The MSBuild Sdk's project are named **Scal.Sdk.xxx**, see [Scal.Sdk](https://github.com/Scal-Human/Scal.Sdk).
