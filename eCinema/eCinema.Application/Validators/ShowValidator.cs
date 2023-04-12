using eCinema.Core;
using FluentValidation;

namespace eCinema.Application
{
    public class ShowValidator : AbstractValidator<ShowUpsertDto>
    {
        public ShowValidator()
        {
            RuleFor(c => c.Format).NotNull().WithErrorCode(ErrorCodes.NotEmpty);
            RuleFor(c => c.Date).NotNull().WithErrorCode(ErrorCodes.NotNull);
            RuleFor(c => c.StartTime).NotNull().WithErrorCode(ErrorCodes.NotNull);
            RuleFor(c => c.CinemaId).NotNull().WithErrorCode(ErrorCodes.NotNull);
            RuleFor(c => c.MovieId).NotNull().WithErrorCode(ErrorCodes.NotNull);
        }
    }
}
