"""
File Name:

Authors: Kyle Seidenthal

Date: 05-09-2019

Description: A python module that allows autocompletion of bitex entry tags

"""

import os

REFS_NAME = 'refs.bib'
TAGS_FILE_NAME = '.kyle_vim_latex_bibtex_file.txt'


def autocomplete_bibtex(working_directory):
    """
    Parse the project's refs.bib file for its tags for autocompletion

    :param working_directory: The directory containing the project
    :returns: None
    """

    path_to_refs = _find_bib_file(working_directory)

    if path_to_refs is None:
        return False

    tags = _load_and_parse_bib_tags(path_to_refs)

    _write_tags_file(tags)


def clean_up_autocomplete_file():
    """
    Remove the tags file for autocompletion

    :returns: None
    """

    os.remove(TAGS_FILE_NAME)


def _find_bib_file(working_directory):
    """
    Find the 'refs.bib' file in the project directory

    :param working_directory: The directory containing the project
    :returns: The path to the refs.bib file
    """
    for root, dirs, files in os.walk(working_directory):
        if REFS_NAME in files:
            return os.path.join(root, REFS_NAME)


def _load_and_parse_bib_tags(path_to_bib_file):
    """
    Load the bibtex file and parse the tags into a list

    :param path_to_bib_file: The path to the bibtex file
    :returns: A list of the tags for the entries
    """

    bib_tags = []

    with open(path_to_bib_file, 'r') as bibfile:
        for line in bibfile:
            if "@" in line:
                line_parts = line.split("{")
                bib_tag = line_parts[1].replace(",", "")
                bib_tags.append(bib_tag)

    return bib_tags


def _write_tags_file(tags):
    """
    Write out a text file with all the bibtex tags in it

    :param tags: A list of the tags to write out to the file
    :returns: None, the file will be written in the curent directory
    """
    with open(TAGS_FILE_NAME, 'w') as outfile:
        for tag in tags:
            outfile.write(tag)
