using eCinema.Core;
using FluentValidation;

namespace eCinema.Application.Validators
{
    public class WeekDayValidator : AbstractValidator<WeekDayUpsertDto>
    {
        public WeekDayValidator()
        {
            RuleFor(c => c.Name).NotEmpty().WithErrorCode(ErrorCodes.NotEmpty);
        }
    }
}
