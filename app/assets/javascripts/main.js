$(function() {
  // DATE UTILITY FUNCTIONS
  Date.prototype.startOfWeek = function() {
    return new Date (
      this.getFullYear(),
      this.getMonth(),
      this.getDate() - this.getDay()
    );
  };
  Date.prototype.endOfWeek = function() {
    return new Date (
      this.getFullYear(),
      this.getMonth(),
      this.getDate() + 6 - this.getDay()
    );
  };
  Date.prototype.endOfNextWeek = function() {
    return new Date (
      this.getFullYear(),
      this.getMonth(),
      this.getDate() + 13 - this.getDay()
    );
  };
  Date.prototype.startOfMonth = function() {
    return new Date (
      this.getFullYear(),
      this.getMonth(),
      1
    );
  };
  Date.prototype.endOfMonth = function() {
    return new Date (
      this.getFullYear(),
      this.getMonth() + 1,
      0 //0 is equal to last day of next month
    );
  };
  //javascript creates a local version of datetimes on creation (6 hours behind UTC)
  Date.prototype.correct = function() {
    // var utc = new Date(this.getUTCFullYear(), this.getUTCMonth(), this.getUTCDate(),  this.getUTCHours(), this.getUTCMinutes(), this.getUTCSeconds());
    // return utc;
    this.setHours(this.getHours() + 6);
  };
  var now = new Date();
  var corrected = now.correct();
  console.log( now );
  console.log( corrected );

  Date.prototype.format = function() {
    var year = this.getFullYear();

    var month = this.getMonth() + 1;
    if ( month < 10 ) { month = '0' + month; }

    var day = this.getDate();
    if ( day < 10 ) { day = '0' + day; }

    return year + '-' + month + '-' + day;
  };

  // ********* INITIALIZATION *********
  if (typeof gon != "undefined") {
    var date1 = new Date(gon.date1);
    var date2 = new Date(gon.date2);
    var filter = gon.filter;

    date1.correct();
    date2.correct();
    $('#filter').val(filter);
  }

  // FILTER DROPDOWN 
  $('#filter').on('change', function() {
    filter = $(this).val();
    $('.main-calendar').attr('data-filter', $(this).val());
  });
  // CALENDAR
  if ( $('.main-calendar').length ) {
    $(".main-calendar").datepicker({
      dateFormat: 'yy-mm-dd',
      showOtherMonths: true,
      showMonth: true,
      defaultDate: date1,
      beforeShowDay: highlightDays,
      onSelect: function(dateText, inst) {
        var beg = new Date(dateText);
        var end = new Date(dateText);

        beg.correct();
        end.correct();

        switch (filter) {
          case 'daily':
          break;
          case 'weekly':
          beg = beg.startOfWeek();
          end = end.endOfWeek();
          break;
          case 'bi-weekly':
          beg = beg.startOfWeek();
          end = end.endOfNextWeek();
          break;
          case 'monthly':
          beg = beg.startOfMonth();
          end = end.endOfMonth();
          break;
        }

        window.location = '/' + $('#filter').val() + '/shifts/' + beg.format() + '/' + end.format();
        
      }
    });
  }
  
  function highlightDays(calendarDate) {
    // between months (start)
    if ( date1.getMonth() < calendarDate.getMonth() && date2.getMonth() === calendarDate.getMonth() && calendarDate.getDate() <= date2.getDate() ) {
      return [true, 'highlight', ''];
    }
    // between months (end )
    else if ( date2.getMonth() > calendarDate.getMonth() && date1.getMonth() === calendarDate.getMonth() && calendarDate.getDate() >= date1.getDate() ) {
      return [true, 'highlight', ''];
    }
    // regular test
    else if ( date1.getMonth() == date2.getMonth() && calendarDate.getDate() >= date1.getDate() && calendarDate.getDate() <= date2.getDate() ) {
      return [true, 'highlight', ''];
    }
    return [true, '', ''];
  }

  // ********* AJAX *********
  // CREATE
  $('.new_task').on('submit', function(e) {
    //set project-id on task befor submitting
    projectId = $('.projects-table tr.active').data('id');
    $('#task_project_id').val( projectId );
  });

  // DELETE
  $('.table').on('click', '.delete', function(e) {
    e.preventDefault();
    e.stopPropagation();

    //save table and item
    table = $(this).closest('table');
    itemId = $(this).closest('tr').data('id');
    $.ajax( {
      type: 'delete',
      url: $(this).attr('href'),
      data: { },
      dataType: 'json',
      error: function() {
        alert('error');
      },
      success: function(json) {
        if ( table.hasClass('projects-table') ) {
          //remove tasks of this project
          $('.tasks-table tbody tr[data-project-id="' + itemId + '"]').remove();
          //change active row to all projects
          $('.all-projects').trigger('click');
        }
        // remove row
        itemToDelete = table.find('tr[data-id="' + json.id + '"]');
        itemToDelete.children('td').effect('highlight', {color: 'hsl(0, 66%, 76%)'}, 400, function() {
          itemToDelete.remove();
          displayNoTasksMessage();
        });
      }
    });
  });
  // UPDATE TASKS
  $('.rt-project').on('change', function(e) {
    var project = $(this);
    var rt_container = project.closest('.rt-pair');
    var task = rt_container.find('.rt-task');
    var task_container = task.parent();

    var project_id = project.val();
    $.ajax( {
      type: 'get',
      url: '/tasks/retreive_tasks',
      data: { 'project_id': project_id, 'task_id': task.attr('id'), 'task_class': task.attr('class'), 'task_name': task.attr('name') },
      dataType: 'text',
      error: function() {
        alert('error');
      },
      success: function(data) {
        task.remove();
        task_container.append($(data));
      }
    });
  });

  // ********* STYLING *********
  // bi-weekly hover styling 
  $('.main-calendar td').hover( function() {
    $(this).closest('tr').find('a, span').addClass('hover-style');
    $(this).closest('tr').next().find('a, span').addClass('hover-style');
  }, function() {
    $(this).closest('tr').find('a, span').removeClass('hover-style');
    $(this).closest('tr').next().find('a, span').removeClass('hover-style');
  });

  // ********* BY-PAGE *********
  $( ".users-create.sign-up .new-user-trigger" ).text('Back To Login...');
  // *** HOME-PAGE (SESSIONS-NEW) ***
  $( ".new-user-trigger" ).on('click', function(e) {
    e.preventDefault();
    e.stopPropagation();

    if ( $(this).text() == 'New User?' ) {
      $(this).fadeOut('fast', function() {
        $(this).text('Back To Login...').fadeIn('fast');
      });
    } else {
      $(this).fadeOut('fast', function() {
        $(this).text('New User?').fadeIn('fast');
      });
    }
    $('.new-user-form').slideToggle();
    $('.login-form').fadeToggle();
  });

  // *** SHIFTS EDIT ***
  $( ".shifts-edit .daily" ).on('click', function(e) {
    e.preventDefault();
    e.stopPropagation();

    var editPath = '/daily/shifts/' + $("#shift_date_in").val() + '/'+ $("#shift_date_in").val();
    window.location = editPath;
  });

  // *** REPORTS ***
  function enableDisableProjects(checkbox) {
    if ( checkbox.is(':checked') ) {
      $('#report_project_id').removeClass('disabled');
    } else {
      $('#report_project_id').addClass('disabled');
    }
  }

  function enableDisableTasks(checkbox) {
    if ( checkbox.is(':checked') ) {
      $('#report_task_id').removeClass('disabled');
    } else {
      $('#report_task_id').addClass('disabled');
    }
  }

  $('#report_project_filter').on('change', function() {
    enableDisableProjects($(this));
  });

  $('#report_task_filter').on('change', function() {
    enableDisableTasks($(this));
  });

  function populateEmailAddress() {
    $('#report_email').val( $('#report_project_id :selected').data('email') );
  }

  $('#report_project_id').on('change', function() {
    populateEmailAddress();
  });

  // SUBMIT FORM TO DIFFERENT ACTIONS
  $('.new_report input[type=submit]').on('click', function(e) {
    if ( $(this).val() == 'Preview' ) {
      $('.new_report').attr('target', "_blank");
      $('.new_report').removeAttr('data-remote');
      $('.new_report').attr('action', '/reports.pdf');
    } else if ( $(this).val() == 'Email' ) {
      $('.new_report').removeAttr('target');
      $('.new_report').attr('data-remote', true);
      $('.new_report').attr('action', '/reports.json');

      $('.email-status').delay(400).fadeIn(600).delay(2500).fadeOut(600);
    } else {
      $('.new_report').removeAttr('target');
      $('.new_report').removeAttr('data-remote');
      $('.new_report').attr('action', '/reports.html');
    }
  });

  // INITIALIZATION
  enableDisableProjects($('#report_project_filter'));
  enableDisableTasks($('#report_task_filter'));
  populateEmailAddress();

  // *** PROJECTS/TASKS INDEX ***
  function displayNoTasksMessage() {
    // display text for no tasks
    if ( $('.tasks-table tbody').height() > 0 ) {
      $('.no-tasks').addClass('hide');
    } else {
      $('.no-tasks').removeClass('hide');
    }
  }

  $('.projects-table tbody').on('click', 'tr', function() {
    // display tasks by project
    $('.projects-table tbody tr').removeClass('active');
    $(this).addClass('active');
    if ( $(this).data('id') == '-1' ) {
      $('.new_task .new').prop('disabled', true);
      $('.tasks-table tbody tr').removeClass('hide');
    } else {
      $('.tasks-table tbody tr').addClass('hide');
      $('.tasks-table tbody tr[data-project-id="' + $(this).data('id') + '"]').removeClass('hide');
      $('.new_task .new').prop('disabled', false);
    }
    displayNoTasksMessage();
  });
  // DISABLE TASKS NEW BUTTON 
  $('.all-projects').trigger('click');
});