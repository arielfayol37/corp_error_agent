from importlib.metadata import distributions
from packaging.requirements import Requirement

# Build the dependency graph
graph: dict[str, set[str]] = {}
for dist in distributions():
    name = dist.metadata.get('Name', '').lower()
    if not name:
        continue
    reqs = dist.requires or []
    deps: set[str] = set()
    for req in reqs:
        try:
            parsed = Requirement(req)
            deps.add(parsed.name.lower())
        except Exception:
            # fallback: take the first token (package name)
            deps.add(req.split()[0].lower())
    graph[name] = deps

# Compute direct (roots) and indirect (transitive) packages
all_pkgs = set(graph.keys())
all_deps = set(dep for deps in graph.values() for dep in deps)

direct = sorted(all_pkgs - all_deps)
indirect = sorted(all_pkgs & all_deps)

# Map each indirect package to its parent(s)
parents: dict[str, list[str]] = {
    pkg: sorted([parent for parent, deps in graph.items() if pkg in deps])
    for pkg in indirect
}

# Display the results
print("Direct (root) packages:")
for pkg in direct:
    print(f" - {pkg}")

print("\nIndirect (transitive) packages and their parent(s):")
for pkg in indirect:
    print(f" - {pkg} (via {', '.join(parents[pkg])})")
