
using eCinema.Core;
using FluentValidation;

namespace eCinema.Application.Validators
{
    public class ReccuringShowValidator : AbstractValidator<ReccuringShowUpsertDto>
    {
        public ReccuringShowValidator()
        {
            RuleFor(c => c.ShowTime).NotNull().WithErrorCode(ErrorCodes.NotNull);
            RuleFor(c => c.StartingDate).NotNull().WithErrorCode(ErrorCodes.NotNull);
            RuleFor(c => c.EndingDate).NotNull().WithErrorCode(ErrorCodes.NotNull);
            RuleFor(c => c.WeekDayId).NotNull().WithErrorCode(ErrorCodes.NotNull);
        }
    }
}
