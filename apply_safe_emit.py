import os
import re

def process_file(file_path):
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()
    
    if 'emit(' in content:
        # Avoid double import
        if 'safe_emit.dart' not in content:
            # Find the best place for import
            import_statement = "import 'package:ala_feen/core/utils/safe_emit.dart';\n"
            # Insert after the last import
            last_import = 0
            lines = content.split('\n')
            for i, line in enumerate(lines):
                if line.startswith('import '):
                    last_import = i
            
            lines.insert(last_import + 1, import_statement)
            content = '\n'.join(lines)
        
        # Replace emit( with safeEmit(
        # Use regex to be more precise if needed, but simple replace usually works for Cubits
        content = content.replace('emit(', 'safeEmit(')
        
        with open(file_path, 'w', encoding='utf-8') as f:
            f.write(content)
        print(f"Processed: {file_path}")

def main():
    root_dir = r"f:\Apps\ala_feen\lib"
    for root, dirs, files in os.walk(root_dir):
        for file in files:
            if file.endswith('_cubit.dart'):
                process_file(os.path.join(root, file))

if __name__ == "__main__":
    main()
