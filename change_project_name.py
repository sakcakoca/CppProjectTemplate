import os
import fileinput
import re
import sys


class NameChanger:

    @staticmethod
    def find_and_replace(directory, existing_string, new_string):
        print("Directory: " + str(directory))
        print("String to be replaced: " + existing_string)
        print("New string: " + new_string)

        file_list = NameChanger.__get_all_files(directory)
        #print("All files found in directory: " + str(file_list))

        NameChanger.__find_and_replace_string_in_file_content(file_list, existing_string, new_string)
        NameChanger.__replace_file_names(file_list, existing_string, new_string)
        NameChanger.__remove_new_created_backup_files(directory, file_list)

    @staticmethod
    def __get_all_files(directory):
        files_found = []
        for root, directories, files in os.walk(directory):
            for file_name in files:
                files_found.append(os.path.join(root, file_name))

        return files_found

    @staticmethod
    def __find_and_replace_string_in_file_content(file_list, existing_string, new_string):
        for file_name in file_list:
            with fileinput.FileInput(file_name, inplace=True) as file:
                for line in file:
                    print(NameChanger.__replace_occurrences(line, existing_string, new_string), end='')

    @staticmethod
    def __replace_occurrences(line, existing_string, new_string):
        case_insensitive_regex = re.compile(re.escape(existing_string), re.IGNORECASE)
        return case_insensitive_regex.sub(new_string, line)

    @staticmethod
    def __replace_file_names(file_list, existing_string, new_string):
        for file_name in file_list:
            old_file_name = file_name
            new_file_name = NameChanger.__replace_occurrences(file_name, existing_string, new_string)

            if not old_file_name == new_file_name:
                os.rename(old_file_name, new_file_name)

    @staticmethod
    def __remove_new_created_backup_files(directory, old_file_list):
        backup_file_extension = ".bak"
        new_file_list = NameChanger.__get_all_files(directory)
        diff_between_new_and_old_file_list = []

        for file_name in new_file_list:
            if not file_name in old_file_list:
                diff_between_new_and_old_file_list.append(file_name)

        for file_name in diff_between_new_and_old_file_list:
            file_extension = os.path.splitext(file_name)[1]
            if file_extension == backup_file_extension:
                print("Remove: " + str(file_name))
                os.remove(file_name)


class ArgumentParser:

    @staticmethod
    def get_parsed_arguments(arguments):
        print("Arguments: " + str(arguments))
        print("Argument count: " + str(len(arguments)))
        ArgumentParser.__validate_arguments(arguments)

        path = arguments[0]
        absolute_path = os.path.abspath(path)

        existing_string = arguments[1]
        new_string = arguments[2]

        return absolute_path, existing_string, new_string

    @staticmethod
    def __validate_arguments(arguments):
        expected_arg_count = 3  # directory, existing_string, new_string

        if len(arguments) < expected_arg_count:
            print("Expected arguments are not supplied")
            print("Please provide directory path, existing string to be replaced and new string")
            print("Example usage: change_project_name.py \"C:/Users/user/\" \"str_to_replace\" \"new_str\"")
            sys.exit(1)


if __name__ == '__main__':
    path_arg, existing_string_arg, new_string_arg = ArgumentParser.get_parsed_arguments(sys.argv[1:])   # 1: used to eliminate .py file name form argument list
    NameChanger.find_and_replace(path_arg, existing_string_arg, new_string_arg)
