"""Runnable Hooks

Every module (hook) in this package has a run method with the following signature which executes
that hook: run(new_task, old_task=None).
"""

from hooks.utils import log


def run(*task_dicts):
    """Runs all Runners.

    Dynamic imports are used to ensure that the logger is initialized globally.

    Args:
        task_dicts: Either (new_task,) or (new_task, old_task).
    """
    log.init_logger()
    logger = log.getLogger()

    for T in task_dicts:
        logger.vdebug('Task Dictionary: %s', T)

    from hooks.runners import active
    from hooks.runners import github
    from hooks.runners import repeats
    from hooks.runners import tags
    from hooks.runners import validate

    new_task = tags.run(*task_dicts)
    new_task = validate.run(*task_dicts)
    new_task = github.run(*task_dicts)
    new_task = active.run(*task_dicts)
    new_task = repeats.run(*task_dicts)
    return new_task