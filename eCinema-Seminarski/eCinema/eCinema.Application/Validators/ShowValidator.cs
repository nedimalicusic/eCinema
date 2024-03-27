using eCinema.Core;
using FluentValidation;

namespace eCinema.Application
{
    public class ShowValidator : AbstractValidator<ShowUpsertDto>
    {
        public ShowValidator()
        {
            RuleFor(c => c.StartsAt).NotNull().WithErrorCode(ErrorCodes.NotNull);
            RuleFor(c => c.ShowTypeId).NotNull().WithErrorCode(ErrorCodes.NotNull);
            RuleFor(c => c.CinemaId).NotNull().WithErrorCode(ErrorCodes.NotNull);
            RuleFor(c => c.MovieId).NotNull().WithErrorCode(ErrorCodes.NotNull);
        }
    }
}
