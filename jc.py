import os
import sys
import traceback


def get_coffee_files(startDir):
    result = []
    for dirname, dirnames, filenames in os.walk(startDir):
        if '.git' in dirnames:
            dirnames.remove(".git")

        for filename in filenames:
            fname, fileExt = os.path.splitext(filename)
            assert(fname not in result)
            if fileExt == ".coffee":
                result.append(FileNode(fname, os.path.join(dirname, filename)))

    return result

class FileNode:

    def __init__(self, moduleName, path_to_src):
        self.dependants = []
        self.referenced_by = []
        self.compiled = False
        self.moduleName = moduleName[0].upper() + moduleName[1:]
        
        f = open(path_to_src)
        self.source = f.read()

        self.marked_temporarily = False

    def depends_on(self, fileNode):
        name = "Chat.%s" % (fileNode.moduleName)
        return name in self.source and self is not fileNode

    def compute_dependencies(self, fileNodes):
        for node in fileNodes:
            if self.depends_on(node):
                self.dependants.append(node)
                node.referenced_by.append(self)
        
    def write_src_to(self, f):
        f.write(self.source)
        f.write("\n\n")

    def __repr__(self):
        return self.moduleName

orderedFiles = []

def visit(node):
    # print "visit", node.moduleName
    if node.compiled: return
    if node.marked_temporarily and not node.compiled: raise Exception("circular dependencies")
    node.marked_temporarily = True

    for dep in node.dependants:
        visit(dep)

    node.compiled = True
    orderedFiles.append(node)

def determine_ordering(fileNodes):
    while fileNodes:
        node = fileNodes.pop(0)
        if not node.marked_temporarily:
            visit(node)

def write_file():
    for node in orderedFiles:
        node.write_src_to(sys.stdout)


    
if __name__ == "__main__":
    try:
        fileNodes = get_coffee_files("src-cs")
        for node in fileNodes:
            node.compute_dependencies(fileNodes)
        for fn in fileNodes:
            # print fn.moduleName, "referenced_by: ", fn.referenced_by
        determine_ordering(fileNodes)
        write_file()
    except:
        traceback.print_exc()
        open("ordered.coffee", "w+").close()
        

